CREATE PROCEDURE [old].[uspMonitorLoaderDeleteDuplicateInformation] (@DuplicateMonitor AS VARCHAR(5))
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [mdi]
        FROM
            [old].[MonitorLoaderDuplicateInformation] AS [mdi]
        WHERE
            [mdi].[DuplicateMonitor] = @DuplicateMonitor;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspMonitorLoaderDeleteDuplicateInformation';

