CREATE PROCEDURE [old].[uspUpdateGatewaySetting]
    (
        @NetworkID                    NVARCHAR(30),
        @EnableSwitch                 BIT,
        @ReceivingApplication         NVARCHAR(30),
        @SendingApplication           NVARCHAR(30),
        @OrganizationID               INT,
        @SendSystemID                 INT,
        @Results_usid                 INT,
        @SleepSeconds                 INT,
        @DebugLevel                   INT,
        @UnitOrganizationID           INT,
        @PatientIDType                CHAR(4),
        @GatewayType                  CHAR(4),
        @AutoAssignIDSwitch           BIT,
        @NewMedicalRecordNumberFormat NVARCHAR(80),
        @AutoChannelAttachSwitch      BIT,
        @LiveVitalsSwitch             BIT,
        @LiveWaveformSize             INT,
        @DecnetNumber                 INT,
        @NodeName                     CHAR(5),
        @NodesExcluded                NVARCHAR(255),
        @NodesIncluded                NVARCHAR(255),
        @TimemasterSwitch             BIT,
        @WaveformSize                 INT,
        @PrintEnabledSwitch           BIT,
        @AutoRecordAlarmSwitch        BIT,
        @CollectTwelveLeadSwitch      BIT,
        @PrintAutoRecordSwitch        BIT,
        @EncryptionStatus             BIT,
        @GatewayID                    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Gateway]
        SET
            [NetworkID] = @NetworkID,
            [HostName] = N'localhost',
            [EnableSwitch] = @EnableSwitch,
            [ReconnectSeconds] = 0,
            [ReceivingApplication] = @ReceivingApplication,
            [SendingApplication] = @SendingApplication,
            [OrganizationID] = @OrganizationID,
            [SendSystemID] = @SendSystemID,
            [results_usid] = @Results_usid,
            [SleepSeconds] = @SleepSeconds,
            [AddMonitorsSwitch] = 1,
            [DebugLevel] = @DebugLevel,
            [UnitOrganizationID] = @UnitOrganizationID,
            [PatientIDType] = @PatientIDType,
            [AddPatientsSwitch] = 1,
            [GatewayType] = @GatewayType,
            [AutoAssignIDSwitch] = @AutoAssignIDSwitch,
            [NewMedicalRecordNumberFormat] = @NewMedicalRecordNumberFormat,
            [AutoChannelAttachSwitch] = @AutoChannelAttachSwitch,
            [LiveVitalsSwitch] = @LiveVitalsSwitch,
            [LiveWaveformSize] = @LiveWaveformSize,
            [DecnetNode] = @DecnetNumber,
            [NodeName] = @NodeName,
            [NodesExcluded] = @NodesExcluded,
            [NodesIncluded] = @NodesIncluded,
            [TimeMasterSwitch] = @TimemasterSwitch,
            [WaveformSize] = @WaveformSize,
            [PrintEnabledSwitch] = @PrintEnabledSwitch,
            [AutoRecordAlarmSwitch] = @AutoRecordAlarmSwitch,
            [CollectTwelveLeadSwitch] = @CollectTwelveLeadSwitch,
            [PrintAutoRecordSwitch] = @PrintAutoRecordSwitch,
            [EncryptionStatus] = @EncryptionStatus
        WHERE
            [GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateGatewaySetting';

