CREATE PROCEDURE [old].[uspRelCleanUp]
AS
    BEGIN
        SET NOCOUNT ON;

        TRUNCATE TABLE [Intesys].[PatientMonitor];

        TRUNCATE TABLE [Intesys].[MonitorRequest];

        TRUNCATE TABLE [Intesys].[Monitor];

        TRUNCATE TABLE [HL7].[InputQueueHistory];

        TRUNCATE TABLE [HL7].[InputQueue];

        TRUNCATE TABLE [HL7].[MessageAcknowledgement];

        TRUNCATE TABLE [HL7].[OutputQueue];

        TRUNCATE TABLE [Intesys].[AuditLog];

        TRUNCATE TABLE [Intesys].[AutoUpdateLog];

        TRUNCATE TABLE [Intesys].[BroadcastMessage];

        TRUNCATE TABLE [Intesys].[ClientMap];

        TRUNCATE TABLE [Intesys].[LoaderStatistic];

        TRUNCATE TABLE [Intesys].[MessageLog];

        TRUNCATE TABLE [Intesys].[OutboundQueue];

        TRUNCATE TABLE [Archive].[MasterPatientIndexDecisionLog];

        TRUNCATE TABLE [Archive].[MasterPatientIndexDecisionQueue];

        TRUNCATE TABLE [Archive].[MasterPatientIndexPatientLink];

        TRUNCATE TABLE [Archive].[MasterPatientIndexSearchWork];

        TRUNCATE TABLE [Intesys].[Environment];

        TRUNCATE TABLE [Intesys].[PreferenceDifference];

        TRUNCATE TABLE [Intesys].[SecurityDifference];

        TRUNCATE TABLE [Intesys].[ResultFlag];

        TRUNCATE TABLE [Intesys].[OrganizationShiftSchedule];

        TRUNCATE TABLE [Intesys].[TranslateList];

        TRUNCATE TABLE [User].[Group];

        TRUNCATE TABLE [User].[Password];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRelCleanUp';

