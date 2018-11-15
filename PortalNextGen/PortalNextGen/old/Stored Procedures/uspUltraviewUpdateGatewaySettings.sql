CREATE PROCEDURE [old].[uspUltraviewUpdateGatewaySettings]
    (
        @GatewayType                   NVARCHAR(10),
        @NetworkName                   NVARCHAR(20),
        @NetworkID                     NVARCHAR(30),
        @NodeName                      CHAR(5),
        @NodeID                        CHAR(1024),
        @uvworganizationID            INT,
        @uvwunitID                    INT,
        @includeNumberdes                 NVARCHAR(255),
        @excludeNumberdes                 NVARCHAR(255),
        @uvwdoNumbert_store_waveforms     TINYINT,
        @print_requests                TINYINT,
        @make_time_master              TINYINT,
        @auto_assignID                TINYINT,
        @new_MedicalRecordNumberformat NVARCHAR(10),
        @uvwprint_alarms               TINYINT,
        @DebugLevel                    INT,
        @GatewayID                     INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [DataLoader].[UltraViewTemporarySettings]
        SET
            [GatewayType] = @GatewayType,
            [NetworkName] = @NetworkName,
            [NetworkID] = @NetworkID,
            [NodeName] = @NodeName,
            [NodeID] = @NodeID,
            [UvwOrganizationID] = @uvworganizationID,
            [UvwUnitID] = @uvwunitID,
            [IncludeNodes] = @includeNumberdes,
            [ExcludeNodes] = @excludeNumberdes,
            [UvwDoNotStoreWaveforms] = @uvwdoNumbert_store_waveforms,
            [PrintRequests] = @print_requests,
            [MakeTimeMaster] = @make_time_master,
            [AutoAssignID] = @auto_assignID,
            [NewMedicalRecordNumberFormat] = @new_MedicalRecordNumberformat,
            [UvwPrintAlarms] = @uvwprint_alarms,
            [DebugLevel] = @DebugLevel
        WHERE
            [GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUltraviewUpdateGatewaySettings';

