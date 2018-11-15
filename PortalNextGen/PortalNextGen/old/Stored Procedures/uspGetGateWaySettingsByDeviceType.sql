CREATE PROCEDURE [old].[uspGetGateWaySettingsByDeviceType] (@GatewayType NVARCHAR(10))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ig].[GatewayID],
            [ig].[GatewayType],
            [ig].[NetworkID],
            [ig].[HostName],
            [ig].[EnableSwitch],
            [ig].[ReceivingApplication],
            [ig].[SendingApplication],
            [ig].[ReconnectSeconds],
            [ig].[OrganizationID],
            [ig].[SendSystemID],
            [ig].[results_usid],
            [ig].[SleepSeconds],
            [ig].[AddMonitorsSwitch],
            [ig].[AddPatientsSwitch],
            [ig].[AddResultsSwitch],
            [ig].[DebugLevel],
            [ig].[UnitOrganizationID],
            [ig].[PatientIDType],
            [ig].[AutoAssignIDSwitch],
            [ig].[NewMedicalRecordNumberFormat],
            [ig].[AutoChannelAttachSwitch],
            [ig].[LiveVitalsSwitch],
            [ig].[LiveWaveformSize],
            [ig].[DecnetNode],
            [ig].[NodeName],
            [ig].[NodesExcluded],
            [ig].[NodesIncluded],
            [ig].[TimeMasterSwitch],
            [ig].[WaveformSize],
            [ig].[PrintEnabledSwitch],
            [ig].[AutoRecordAlarmSwitch],
            [ig].[CollectTwelveLeadSwitch],
            [ig].[PrintAutoRecordSwitch],
            [ig].[EncryptionStatus]
        FROM
            [Intesys].[Gateway] AS [ig]
        WHERE
            [ig].[GatewayType] = @GatewayType
        ORDER BY
            [ig].[NetworkID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetGateWaySettingsByDeviceType';

