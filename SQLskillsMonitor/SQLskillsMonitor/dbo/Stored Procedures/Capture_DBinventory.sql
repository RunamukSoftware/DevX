
-- =============================================
-- Author:		<Tim Radney>
-- Create date: <Feb 4th 2016>
-- Description:	<Capture Page Life Expectancy>
--Copyright 2016 - SQLskills.com
-- =============================================
CREATE PROCEDURE [dbo].[Capture_DBinventory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/* Find free space for each database data and log file
http://www.mssqltips.com/tip.asp?tip=1426
*/
DECLARE @DBInfo TABLE 
( ServerName VARCHAR(100), 
DatabaseName VARCHAR(100), 
FileSizeMB INT, 
LogicalFileName sysname, 
PhysicalFileName NVARCHAR(520), 
Status sysname, 
Updateability sysname, 
RecoveryMode sysname, 
FreeSpaceMB INT, 
FreeSpacePct numeric(5,2), 
FreeSpacePages INT, 
CAPTURE_DATE datetime,
FileGroupName VARCHAR(100),
growth VARCHAR(25)) 

DECLARE @command VARCHAR(6000) 

SELECT @command = 'Use [' + '?' + '] SELECT 
@@servername as ServerName, 
' + '''' + '?' + '''' + ' AS DatabaseName, 
CAST(f.size/128.0 AS int) AS FileSize, 
f.name AS LogicalFileName, f.filename AS PhysicalFileName, 
CONVERT(sysname,DatabasePropertyEx(''?'',''Status'')) AS Status, 
CONVERT(sysname,DatabasePropertyEx(''?'',''Updateability'')) AS Updateability, 
CONVERT(sysname,DatabasePropertyEx(''?'',''Recovery'')) AS RecoveryMode, 
CAST(f.size/128.0 - CAST(FILEPROPERTY(f.name, ' + '''' + 
       'SpaceUsed' + '''' + ' ) AS int)/128.0 AS int) AS FreeSpaceMB, 
100 * (CAST (((f.size/128.0 -CAST(FILEPROPERTY(f.name, 
' + '''' + 'SpaceUsed' + '''' + ' ) AS int)/128.0)/(f.size/128.0)) 
AS numeric(4,2)))  AS FreeSpacePct, 
GETDATE() as CAPTURE_DATE, fg.groupname
,''growth'' = (case f.status & 0x100000 when 0x100000 then convert(nvarchar(15), growth) + N''%'' else convert(nvarchar(15), (convert (bigint, growth) * 8)/1024) + N'' MB'' end)
 FROM dbo.sysfiles f LEFT JOIN dbo.sysfilegroups fg ON f.groupid = fg.groupid' 

INSERT INTO @DBInfo 
   (ServerName, 
   DatabaseName, 
   FileSizeMB, 
   LogicalFileName, 
   PhysicalFileName, 
   Status, 
   Updateability, 
   RecoveryMode, 
   FreeSpaceMB, 
   FreeSpacePct, 
   CAPTURE_DATE,
   FileGroupName
   ,Growth
   ) 
EXEC sp_MSForEachDB @command 
INSERT INTO SQLskillsMonitor.dbo.DBinventory
([ServerName],[DatabaseName],[LogicalFileName],[FileGroupName],[Growth],[FileSizeMB],[UsedSizeMB],
[FreeSpaceMB],[PhysicalFileName],[Status],[Updateability],[RecoveryMode],[FreeSpacePct],[CAPTURE_DATE])
SELECT 
   ServerName, 
   DatabaseName, 
   LogicalFileName, 
   FileGroupName,
   Growth,
   FileSizeMB, 
	(FileSizeMB - FreeSpaceMB) UsedSizeMB,   
	FreeSpaceMB,
   PhysicalFileName, 
   Status, 
   Updateability, 
   RecoveryMode, 
   FreeSpacePct, 
   CAPTURE_DATE 
FROM @DBInfo
--WHERE databaseName like 'NFCBOL'--LogicalFileName like 'TP%'
ORDER BY 
   ServerName, 
   DatabaseName, FileGroupName  

END