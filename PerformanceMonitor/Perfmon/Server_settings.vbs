Dim objFS, objShell, objFileW, oEnv, objWMIService
Dim colItems, objItem, colCSes, objCS, dtmConvertedDate, objMem, obj2
Dim MyTime, MyFile, MyLine

On Error Resume Next

strComputer = "."
set objShell = CreateObject("WScript.Shell")
Set oEnv = objShell.Environment("SYSTEM")
set objFS = WScript.CreateObject("Scripting.FileSystemObject")

'calculates time for filename
MyTime= "_" & Replace (Date(),"/","_") & "_" & Replace (Time(),":","_")

'sets the file path
MyFile = "C:\PerfLogs\Spacelabs\" & objShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" ) & MyTime & ".txt"

'set the file to write the settings to
Set objFileW = objFS.CreateTextFile(MyFile, TRUE)
objFileW.Writeline (vbcrlf)

'retrieves the number of processors
'MyLine = "Number of processors: " & oEnv("NUMBER_OF_PROCESSORS")
objFileW.Writeline ("****************PROCESSOR*******************")
'objFileW.Writeline (MyLine)

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set colCSes = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem")
For Each objCS In colCSes
  objFileW.Writeline ("Computer Name: " & objCS.Name)
  objFileW.Writeline ("System Type: " & objCS.SystemType)
  MyType = objCS.SystemType
  objFileW.Writeline ("Number Of Physical Processors: " & objCS.NumberOfProcessors)
  MySockets = objCS.NumberOfProcessors
  objFileW.Writeline ("Number of Logical Processors: " & objCS.NumberofLogicalProcessors)
  'objFileW.Writeline (vbcrlf)
Next
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor")
MyCores = 0
For Each objItem in colItems
    objFileW.Writeline ("NumberOfCores: " & objItem.NumberOfCores)
	MyCores = MyCores + objItem.NumberOfCores
	objFileW.Writeline ("Processor: " & objItem.Name)
    'objFileW.Writeline ("NumberOfLogicalProcessors: " & objItem.NumberOfLogicalProcessors)
    objFileW.Writeline (vbcrlf)
Next
objFileW.Writeline ("Total Number of Cores: " & MyCores)
objFileW.Writeline ("****************MEMORY*******************")
Set objMem = GetObject("winmgmts:").InstancesOf("Win32_PhysicalMemory") 
i = 1
For Each obj2 In objMem 
	memTmp1 = obj2.capacity / 1024 / 1024
	objFileW.Writeline ("Module" & i & ": " & memTmp1 & " MB")
	TotalRam = TotalRam + memTmp1 
	i = i + 1
Next 
objFileW.Writeline ("Total RAM: " & TotalRam & " MB")
objFileW.Writeline (vbcrlf)
objFileW.Writeline ("****************OPERATING SYSTEM*******************")
Set dtmConvertedDate = CreateObject("WbemScripting.SWbemDateTime")
strComputer = "."
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set oss = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each os in oss
    'objFileW.Writeline ("Boot Device: " & os.BootDevice)
    'objFileW.Writeline ("Build Number: " & os.BuildNumber)
    'objFileW.Writeline ("Build Type: " & os.BuildType)
    objFileW.Writeline ("Caption: " & os.Caption)
	MyCaption = os.Caption
    'objFileW.Writeline ("Code Set: " & os.CodeSet)
    'objFileW.Writeline ("Country Code: " & os.CountryCode)
    'objFileW.Writeline ("Debug: " & os.Debug)
    'objFileW.Writeline ("Encryption Level: " & os.EncryptionLevel)
    dtmConvertedDate.Value = os.InstallDate
    dtmInstallDate = dtmConvertedDate.GetVarDate
    objFileW.Writeline ("Install Date: " & dtmInstallDate )
    'objFileW.Writeline ("Licensed Users: " & os.NumberOfLicensedUsers)
    'objFileW.Writeline ("Organization: " & os.Organization)
    'objFileW.Writeline ("OS Language: " & os.OSLanguage)
    'objFileW.Writeline ("OS Product Suite: " & os.OSProductSuite)
    'objFileW.Writeline ("OS Type: " & os.OSType)
    'objFileW.Writeline ("Primary: " & os.Primary)
    'objFileW.Writeline ("Registered User: " & os.RegisteredUser)
    'objFileW.Writeline ("Serial Number: " & os.SerialNumber)
    objFileW.Writeline ("Version: " & os.Version)
	MyVersion = os.Version
Next
objFileW.Writeline (vbcrlf)
'PROCESSING RESULTS
if (Instr(1,MyType,"X86",1)) then
objFileW.Writeline ("OK - 32bit System")
else 
objFileW.Writeline ("THE SYSTEM IS NOT 32-BIT")
end if

if ((TotalRam > 4096) AND (Instr(1,MyCaption,"Standard",1))) then
objFileW.Writeline ("WRONG WINDOWS EDITION - ENTERPRISE OR DATACENTER EDITION REQUIRED!")
else
objFileW.Writeline ("OK - Windows Edition verified")
end if

if (MyVersion <> "6.0.6002") then
objFileW.Writeline ("WRONG WINDOWS VERSION OR SERVICE PACK NUMBER!")
else
objFileW.Writeline ("OK - Windows version and SP number verified")
end if

if (MySockets < 2) then
objFileW.Writeline ("TOO FEW SOCKETS!")
end if

if (MyCores < 4) then
objFileW.Writeline ("TOO FEW CORES!")
end if

objFileW.Close
