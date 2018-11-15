CREATE PROCEDURE [old].[uspEnhancedTelemetryUpdateGatewaySettings]
    (
        @GatewayType                NVARCHAR(10),
        @FarmName                   NVARCHAR(5),
        @network                    NVARCHAR(30),
        @ETDoNotStoreWaveforms      TINYINT,
        @IncludeTransmitterChannels NVARCHAR(255),
        @ExcludeTransmitterChannels NVARCHAR(255),
        @ETPrintAlarms              TINYINT,
        @GatewayID                  INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [DataLoader].[EnhancedTelemetryTemporarySettings]
        SET
            [GatewayType] = @GatewayType,
            [FarmName] = @FarmName,
            [Network] = @network,
            [ETDoNotStoreWaveforms] = @ETDoNotStoreWaveforms,
            [IncludeTransmitterChannels] = @IncludeTransmitterChannels,
            [ExcludeTransmitterChannels] = @ExcludeTransmitterChannels,
            [ETPrintAlarms] = @ETPrintAlarms
        WHERE
            [GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEnhancedTelemetryUpdateGatewaySettings';

