CREATE PROCEDURE [old].[uspAddNewGatewaySetting]
    (
        @GatewayID                    INT,
        @GatewayType                  CHAR(4),
        @NetworkID                    NVARCHAR(30),
        @EnableSwitch                 BIT,
        @recvwapp                     NVARCHAR(30),
        @SendApplication              NVARCHAR(30),
        @OrganizationID               INT,
        @SendSystemID                 INT,
        @Results_usid                 INT,
        @SleepSeconds                 INT,
        @DebugLevel                   INT,
        @UnitOrganizationID           INT,
        @PatientIDType                CHAR(4),
        @AutoAssignIDSwitch           BIT,
        @NewMedicalRecordNumberFormat NVARCHAR(80),
        @AutoChannelAttachSwitch      BIT,
        @LiveVitalsSwitch             BIT,
        @LiveWaveformSize             INT,
        @DecnetNode                   INT,
        @NodeName                     CHAR(5),
        @NodesExcluded                NVARCHAR(255),
        @NodesIncluded                NVARCHAR(255),
        @TimeMasterSwitch             BIT,
        @WaveformSize                 INT,
        @PrintEnabledSwitch           BIT,
        @AutoRecordAlarmSwitch        BIT,
        @CollectTwelveLeadSwitch      BIT,
        @PrintAutoRecordSwitch        BIT,
        @EncryptionStatus             BIT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Gateway]
            (
                [GatewayID],
                [GatewayType],
                [NetworkID],
                [HostName],
                [EnableSwitch],
                [ReceivingApplication],
                [SendingApplication],
                [ReconnectSeconds],
                [OrganizationID],
                [SendSystemID],
                [results_usid],
                [SleepSeconds],
                [AddMonitorsSwitch],
                [AddPatientsSwitch],
                [DebugLevel],
                [UnitOrganizationID],
                [PatientIDType],
                [AutoAssignIDSwitch],
                [NewMedicalRecordNumberFormat],
                [AutoChannelAttachSwitch],
                [LiveVitalsSwitch],
                [LiveWaveformSize],
                [DecnetNode],
                [NodeName],
                [NodesExcluded],
                [NodesIncluded],
                [TimeMasterSwitch],
                [WaveformSize],
                [PrintEnabledSwitch],
                [AutoRecordAlarmSwitch],
                [CollectTwelveLeadSwitch],
                [PrintAutoRecordSwitch],
                [EncryptionStatus]
            )
        VALUES
            (
                @GatewayID, @GatewayType, @NetworkID, N'localhost', @EnableSwitch, @recvwapp, @SendApplication, 0,
                @OrganizationID, @SendSystemID, @Results_usid, @SleepSeconds, 1, 1, @DebugLevel, @UnitOrganizationID,
                @PatientIDType, @AutoAssignIDSwitch, @NewMedicalRecordNumberFormat, @AutoChannelAttachSwitch,
                @LiveVitalsSwitch, @LiveWaveformSize, @DecnetNode, @NodeName, @NodesExcluded, @NodesIncluded,
                @TimeMasterSwitch, @WaveformSize, @PrintEnabledSwitch, @AutoRecordAlarmSwitch,
                @CollectTwelveLeadSwitch, @PrintAutoRecordSwitch, @EncryptionStatus
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspAddNewGatewaySetting';

