# THIS SCRIPT ONLY WORKS ON 64 bit systems!!!

function Decryption($Hashed)
{
[string] $value = $Hashed

[string] $strOut = ''

[int] $nCharLength = 2
[int] $nMaxOffset = 255
[string] $m_strDefaultKey = "phepmagi"
[string] $m_strUnicodePrefix = "5753"

[string] $key = $m_strDefaultKey

if ($value.Substring(0,$m_strUnicodePrefix.Length) -eq $m_strUnicodePrefix)
{
    $nCharLength = 4
    $nMaxOffset = 65535
    $value = $value.Substring($m_strUnicodePrefix.Length)
}

[int] $nSrcPos = $nCharLength
[int] $nKeyPos = -1
[string] $strSrc = $value
[int] $nSrcLen = $strSrc.Length
[int] $nKeyLen = $key.Length
[int] $nSrcAscii = 0
[int] $nTmpSrcAscii = 0

[int] $nOffset = [Convert]::ToInt32($value.Substring(0, $nCharLength), 16)

#Write-Host $nOffset

[int]$nKeyChar =  0
                do
                {
                    $nSrcAscii = [Convert]::ToInt32($strSrc.Substring($nSrcPos, $nCharLength), 16) 
                    #write-host $nSrcAscii

                    if ($nKeyPos -lt ($nKeyLen - 1))
                    {
                        $nKeyPos += 1
                        $nKeyChar = $key[$nKeyPos]
                    }
                    else
                    {
                        $nKeyPos = -1;
                        $nKeyChar = 0;
                    }
					 #write-host $nKeyChar
                    $nTmpSrcAscii = $nSrcAscii -bxor $nKeyChar
					#Write-Host $nTmpSrcAscii  " = "  $nSrcAscii  " ^ "  $nKeyChar
                    if ($nTmpSrcAscii -le $nOffset)
                        {$nTmpSrcAscii += $nMaxOffset - $nOffset}
                    else
                        {$nTmpSrcAscii -= $nOffset}
					#Write-Host $nTmpSrcAscii
                    $strOut += [char]$nTmpSrcAscii
                    $nOffset = $nSrcAscii
                    $nSrcPos += $nCharLength
                } while ($nSrcPos -lt $nSrcLen)
				#write-host $strOut
				return $strOut

}

Function GetUsersfromGroup($GroupName)
{
	$members = @()
	$submembers = @()
	Try	
		{
			$members = Get-ADGroupMember -Identity $GroupName | ?{$_.ObjectClass -eq "user"} | % { Get-ADUser $_.samaccountname | ?{$_.Enabled -eq "True"} | select userprincipalname, SID } | Sort-Object -Property SID
		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5008 -entrytype Error -message $ErrorMessage
		}
		$ErrorMessage = "" 
	
	# retrieves the groups within the current group
	Try	
		{
			$groups = Get-ADGroupMember -Identity $GroupName | ?{$_.ObjectClass -eq "Group"}		
		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5009 -entrytype Error -message $ErrorMessage
		}
		$ErrorMessage = "" 
	
	#recursively, retrieves all the users from the nested groups
    foreach ($group in $groups) 
	{
		$submembers = GetUsersfromGroup($group)
        #fixing a Powershell error if the first array of the addition has only one element 
		$i = 0
        foreach ($submember in $submembers)
        {
            
            if ($members -match $submember.SID.Value)
					{++$i} 
            else 	{$members = $members + $submember}
        }
		if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0)
		{
	    	write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1010 -entrytype 'Information' -message ('Adding users from nested AD Group: ' + $group + '; new user count is ' + $members.Count)
		}
		$ErrorMessage = ""
	}
	
	return $members
}

Function Main()
{


# logs a new cycle
$ErrorActionPreference = "SilentlyContinue"
$ErrorMessage = ""
if(!(Get-Eventlog -LogName 'Application' -Source 'AD_Group_Sync'))
    {
        New-Eventlog -LogName "Application"  -Source 'AD_Group_Sync' | Out-Null
    }
$ErrorActionPreference = "Continue"
write-eventlog -logname 'Application' -source 'AD_Group_Sync' -eventID 1001 -entrytype 'Information' -message "AD Group Sync service started"

# sets the config file path
$ConfigFile = 'C:\Program Files (x86)\Spacelabs\AD_Group_Sync.xml'

	#sets the database connectivity parameters  
	$PortalUser = (Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Spacelabs\CoreSvc").DBUser
    $PortalDB = (Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Spacelabs\CoreSvc").DBName
    $PortalServer = (Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Spacelabs\CoreSvc").DBServer
	#retrieves the hashed password from registry
	[string] $HashedPass = (Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Spacelabs\CoreSvc").DBPassword
	#decrypts the password
	$PortalPassword = Decryption($HashedPass)

#reads the config file and its parameters - generates an error if it fails

Try
        {
            [xml]$Config = Get-Content $ConfigFile -ErrorAction stop
        }
Catch
        {
            $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5001 -entrytype Error -message $ErrorMessage
        }

#enhanced logging
if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
{
    write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1002 -entrytype 'Information' -message 'Config File found - OK'
}
$ErrorMessage = ""
$SyncIntervalSeconds = $Config.AD_Group_Sync_Config.SyncIntervalSeconds

#initializes the DATATABLE
$Datatable = New-Object System.Data.DataTable


# INFINITE LOOP
while ($true) 
{
		$StartTime = Get-Date -format HH:mm:ss
		#connects to database 
		$DBconnectionString = "Server=$PortalServer;uid=$PortalUser; pwd=$PortalPassword;Database=$PortalDB;Integrated Security=False;MultipleActiveResultSets=True"
    	$DBconnection = New-Object System.Data.SqlClient.SqlConnection
    	$DBconnection.ConnectionString = $DBconnectionString
	Try	
		{
			$DBconnection.Open()		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5003 -entrytype Error -message $ErrorMessage
		}
	$ErrorMessage = ""
# parses all the CA_role/AD_Group pair

foreach ($GroupNode in $Config.AD_Group_Sync_Config.AD_Groups.Group)
	{
		$CA_Role = $GroupNode.role
		$AD_Group = $GroupNode.InnerText
	
		# retrieves the users in that AD Group for the specific ICS Role
		
		$AD_Members = GetUsersfromGroup($AD_Group)
		
		if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0)
		{
    		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1011 -entrytype 'Information' -message ('Total number of valid AD users to process is ' + $AD_Members.Count)
		}
		$ErrorMessage = ""
		
		#retrieves the existing usernames for that role
    	
		$DBquery = "SELECT usr.user_sid, usr.login_name, rol.role_name, usr.user_id FROM int_user usr INNER JOIN int_user_role rol ON usr.user_role_id = rol.user_role_id WHERE rol.role_name LIKE '" + $CA_Role + "'  ORDER BY usr.user_sid"
    	$DBcommand = $DBconnection.CreateCommand()
    	$DBcommand.CommandText = $DBquery
   		
	Try	
		{
			$DBresults = $DBcommand.ExecuteReader()		
		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5004 -entrytype Error -message $ErrorMessage
		}		
		$ErrorMessage = ""
		
		$DBRolequery = "SELECT rol.user_role_id, rol.role_name FROM int_user_role rol WHERE rol.role_name LIKE '" + $CA_Role + "'"
		$DBRolecommand = $DBconnection.CreateCommand()
    	$DBRolecommand.CommandText = $DBRolequery
   		
	Try	
		{
			$DBRoleresults = $DBRolecommand.ExecuteReader()		
		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5005 -entrytype Error -message $ErrorMessage
		}
		#enhanced logging
		if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
		{
   			write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1003 -entrytype 'Information' -message ('Sync-ing users in group: ' + $AD_Group + ' with ICS Role: ' + $CA_Role)
		}	
		$ErrorMessage = ""
		
		foreach ($Role in $DBRoleresults)
		{
			$RoleID = $Role["user_role_id"]
		}
		
		
		
#################################################################		
# FIRST PASS - User is in the AD Group but not in that ICS Role (Insert new user in the database)
#     AND
#SECOND PASS - User name has changed but same SID
#################################################################				
		
		if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0)
		{
    		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1009 -entrytype 'Information' -message ('Verifying ICS database for new users or updates' )
		}
		$ErrorMessage = ""
		
		$Datatable.Load($DBresults)
		$Dataview = New-Object System.Data.DataView($Datatable)
		$Dataview.Sort = "user_sid"
		foreach ($Member in $AD_Members)
		{	
		
			#Write-Host $Member.userprincipalname
			#$Dataview.RowFilter = "user_sid = '$Member.SID.Value'"
			$Found = $Dataview.Find($Member.SID.Value)
			if ($Found -ge 0 )
			{
				#Verifies that the username has not changed ( SID is the same)
				if ($Dataview[$Found].login_name -ne $Member.userprincipalname)
				{
					#UserName in AD has changed - needs to be updated in the database
					$DBUPDquery = "UPDATE int_user SET login_name = '" + $Member.userprincipalname + "' WHERE user_sid LIKE '" + $Member.SID.Value + "'"
					$DBUPDcommand = $DBconnection.CreateCommand()
			    	$DBUPDcommand.CommandText = $DBUPDquery
			   		
				Try	
					{
						$DBUPDresults = $DBUPDcommand.ExecuteReader()		
					}
				Catch
					{
					    $ErrorMessage = $_.Exception.Message
			            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5005 -entrytype Error -message $ErrorMessage
					}
					#enhanced logging
					if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
					{
			   			write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1005 -entrytype 'Information' -message ('Username was updated from: ' + $Dataview[$Found].login_name + ' to: ' + $Member.userprincipalname)
					}	
					$ErrorMessage = ""
				}
				
				#AD User is found in the database so the dataview can be cleaned of that row - speeds up finding towards the end
				$Dataview.Delete($Found)
			}	
			else
			{
				#Write-Host $Member.userprincipalname " - NOT FOUND"
				# AD User is not found in the database so it needs to be inserted
				$DBRolequery = "INSERT INTO int_user (user_id, user_role_id, user_sid, login_name) VALUES (NEWID(), '" + $RoleID + "', '" + $Member.SID.Value + "', '" + $Member.userprincipalname + "')"
				$DBRolecommand = $DBconnection.CreateCommand()
    			$DBRolecommand.CommandText = $DBRolequery
   		
			Try	
				{
					$DBRoleresults = $DBRolecommand.ExecuteReader()		
				}
			Catch
				{
		    		$ErrorMessage = $_.Exception.Message
            		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5006 -entrytype Error -message $ErrorMessage
				}
				#enhanced logging
				if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
					{
    					write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1004 -entrytype 'Information' -message ('New user inserted in the database - ' + $Member.userprincipalname)
					}
				$ErrorMessage = ""	
			}
		}
		
		if ($Datatable.Rows.Count -gt 0) { $Datatable.Clear()}
		if ($Dataview.Count -gt 0) { $Dataview.Clear()}
		
#################################################################		
# THIRD PASS - User was deleted from the AD Group but it is still in ICS Admin (Delete old user from the database)
#################################################################				
				
	if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0)
		{
    		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1011 -entrytype 'Information' -message ('Verifying ICS database for obsolete users' )
		}
		$ErrorMessage = ""
	
	
	#reload the datatable since it was cleared and the recordset is closed
	
	Try	
		{
			$DBresults = $DBcommand.ExecuteReader()		
		}
	Catch
		{
		    $ErrorMessage = $_.Exception.Message
            write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5007 -entrytype Error -message $ErrorMessage
		}		
		$ErrorMessage = ""
		
		$Datatable.Load($DBresults)
		#$Dataview = New-Object System.Data.DataView($Datatable)
		#$Dataview.Sort = "user_sid"		
		for($i=0;$i -lt $Datatable.Rows.Count;$i++)
		{
			if ($i%100 -eq 0)
			{
				if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0)
				{
    				write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1012 -entrytype 'Information' -message ('_ ' + $i + ' users verified whether obsolete')
				}
				$ErrorMessage = ""
			}
			
			$FoundUser = $AD_Members | Where-Object {$_.SID -eq $Datatable.Rows[$i].user_sid}
			#if ICS user is not found in Active Directory, delete it
			if ($FoundUser.SID.Value.Length -lt 1 )
			{
			#deletes the user from int_user table
				$DBDELquery = "DELETE FROM int_user WHERE user_sid LIKE '" + $Datatable.Rows[$i].user_sid + "'"
				$DBDELcommand = $DBconnection.CreateCommand()
    			$DBDELcommand.CommandText = $DBDELquery
   		
			Try	
				{
					$DBDELresults = $DBDELcommand.ExecuteReader()		
				}
			Catch
				{
		    		$ErrorMessage = $_.Exception.Message
            		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5006 -entrytype Error -message $ErrorMessage
				}
				#enhanced logging
				if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
					{
    					write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1006 -entrytype 'Information' -message ('Obsolete user deleted from the database - ' + $Datatable.Rows[$i].login_name)
					}
				$ErrorMessage = ""
			
			
				
			}
		}
		
# deletes the user's settings from int_user_settings table - if any
		
		$DBDELquery = "DELETE FROM int_user_settings WHERE NOT EXISTS (SELECT NULL FROM int_user usr WHERE usr.user_id = int_user_settings.user_id)"
		$DBDELcommand = $DBconnection.CreateCommand()
		$DBDELcommand.CommandText = $DBDELquery

	Try	
		{
			$DBDELresults = $DBDELcommand.ExecuteReader()		
		}
	Catch
		{
    		$ErrorMessage = $_.Exception.Message
    		write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 5007 -entrytype Error -message $ErrorMessage
		}
		#enhanced logging
		if (($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) -and ($ErrorMessage.Length -lt 1))
			{
				write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1007 -entrytype 'Information' -message ('Obsolete user settings deleted from the database')
			}
		$ErrorMessage = ""
		
	}
	
	$DBconnection.Close()
	
	$EndTime = Get-Date -format HH:mm:ss
	$TimeDiff = New-TimeSpan -Start $StartTime -End $EndTime
	if ($Config.AD_Group_Sync_Config.EnhancedLog -gt 0) 
	{
    	write-eventlog -logname Application -source 'AD_Group_Sync' -eventID 1008 -entrytype 'Information' -message ('Time elapsed for AD Users sync-ing: ' + $TimeDiff.Hours + ':' + $TimeDiff.Minutes + ':' + $TimeDiff.Seconds)
	}
	
	#pause until next sync cycle less the time took to actually sync
	$ActualWaitTime = $SyncIntervalSeconds - $TimeDiff.TotalSeconds
	if ($ActualWaitTime -gt 0)
		{Start-Sleep -Seconds $ActualWaitTime}
	
}
}



