CREATE PROCEDURE [old].[uspUltraviewAddGatewaySettings]
    (
        @GatewayID                    INT,
        @GatewayType                  NVARCHAR(20),
        @NetworkName                  NVARCHAR(20),
        @NetworkID                    NVARCHAR(30),
        @NodeName                     CHAR(5),
        @NodeID                       CHAR(1024),
        @OrganizationID               INT,
        @UnitID                       INT,
        @IncludeNodes                 NVARCHAR(255),
        @ExcludeNodes                 NVARCHAR(255),
        @DoNotStoreWaveforms          TINYINT,
        @PrintRequests                TINYINT,
        @MakeTimeMaster               TINYINT,
        @AutoAssignID                 TINYINT,
        @NewMedicalRecordNumberformat NVARCHAR(10),
        @PrintAlarms                  TINYINT,
        @DebugLevel                   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [DataLoader].[UltraViewTemporarySettings]
            (
                [GatewayID],
                [GatewayType],
                [NetworkName],
                [NetworkID],
                [NodeName],
                [NodeID],
                [UvwOrganizationID],
                [UvwUnitID],
                [IncludeNodes],
                [ExcludeNodes],
                [UvwDoNotStoreWaveforms],
                [PrintRequests],
                [MakeTimeMaster],
                [AutoAssignID],
                [NewMedicalRecordNumberFormat],
                [UvwPrintAlarms],
                [DebugLevel]
            )
        VALUES
            (
                @GatewayID,
                @GatewayType,
                @NetworkName,
                @NetworkID,
                @NodeName,
                @NodeID,
                @OrganizationID,
                @UnitID,
                @IncludeNodes,
                @ExcludeNodes,
                @DoNotStoreWaveforms,
                @PrintRequests,
                @MakeTimeMaster,
                @AutoAssignID,
                @NewMedicalRecordNumberformat,
                @PrintAlarms,
                @DebugLevel
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUltraviewAddGatewaySettings';

