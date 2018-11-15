CREATE PROCEDURE [old].[uspEnhancedTelemetryAddGatewaySettings]
    (
        @GatewayID                  INT,
        @GatewayType                NVARCHAR(10),
        @FarmName                   NVARCHAR(5),
        @network                    NVARCHAR(30),
        @ETDoNotStoreWaveforms      TINYINT,
        @IncludeTransmitterChannels NVARCHAR(255),
        @ExcludeTransmitterChannels NVARCHAR(255),
        @ETPrintAlarms              TINYINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [DataLoader].[EnhancedTelemetryTemporarySettings]
            (
                [GatewayID],
                [GatewayType],
                [FarmName],
                [Network],
                [ETDoNotStoreWaveforms],
                [IncludeTransmitterChannels],
                [ExcludeTransmitterChannels],
                [ETPrintAlarms]
            )
        VALUES
            (
                @GatewayID,
                @GatewayType,
                @FarmName,
                @network,
                @ETDoNotStoreWaveforms,
                @IncludeTransmitterChannels,
                @ExcludeTransmitterChannels,
                @ETPrintAlarms
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEnhancedTelemetryAddGatewaySettings';

