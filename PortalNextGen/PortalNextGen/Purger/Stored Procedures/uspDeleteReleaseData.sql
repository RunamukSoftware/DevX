CREATE PROCEDURE [Purger].[uspDeleteReleaseData]
AS
    BEGIN
        SET NOCOUNT ON;

        TRUNCATE TABLE [HL7].[InputQueueHistory];

        TRUNCATE TABLE [HL7].[InputQueue];

        TRUNCATE TABLE [HL7].[MessageAcknowledgement];

        TRUNCATE TABLE [HL7].[OutputQueue];

        TRUNCATE TABLE [Intesys].[AutoUpdateLog];

        TRUNCATE TABLE [Intesys].[BroadcastMessage];

        TRUNCATE TABLE [Intesys].[ClientMap];

        TRUNCATE TABLE [Intesys].[LoaderStatistic];

        TRUNCATE TABLE [Intesys].[MonitorRequest];

        TRUNCATE TABLE [Intesys].[Monitor];

        TRUNCATE TABLE [Intesys].[PatientMonitor];

        TRUNCATE TABLE [Intesys].[MessageLog];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteReleaseData';

