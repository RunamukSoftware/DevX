-- =============================================
-- Author:		<Tim Radney>
-- Create date: <Feb 4th 2016>
-- Description:	<Capture Page Life Expectancy>
--Copyright 2016 - SQLskills.com
-- =============================================
CREATE PROCEDURE [dbo].[Capture_PLE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO SQLskillsMonitor.dbo.PLE 
([INSTANCE], [CAPTURE_DATE], [OBJECT_NAME], [COUNTER_NAME], [UPTIME_MIN], [PLE_SECS], [PLE_MINS], [PLE_HOURS], [PLE_DAYS])  
SELECT  @@servername AS INSTANCE
,getdate() [CAPTURE_DATE]
,[OBJECT_NAME]
,[COUNTER_NAME]
, UPTIME_MIN = CASE WHEN[counter_name]= 'Page life expectancy'
          THEN (SELECT DATEDIFF(MI, MAX(login_time),GETDATE())
          FROM   master.sys.sysprocesses
          WHERE  cmd='LAZY WRITER')
      ELSE''
END
, [cntr_value] AS PLE_SECS
,[cntr_value]/ 60 AS PLE_MINS
,[cntr_value]/ 3600 AS PLE_HOURS
,[cntr_value]/ 86400 AS PLE_DAYS
FROM  sys.dm_os_performance_counters
WHERE   [object_name] LIKE '%Manager%'
          AND[counter_name] = 'Page life expectancy'   

END