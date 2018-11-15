CREATE PROCEDURE [old].[uspEnhancedTelemetryGetGatewaySettings] (@GatewayType NVARCHAR(10))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [idlets].[GatewayID],
            [idlets].[GatewayType],
            [idlets].[FarmName],
            [idlets].[Network],
            [idlets].[ETDoNotStoreWaveforms],
            [idlets].[IncludeTransmitterChannels],
            [idlets].[ExcludeTransmitterChannels],
            [idlets].[ETPrintAlarms]
        FROM
            [DataLoader].[EnhancedTelemetryTemporarySettings] AS [idlets]
        WHERE
            [idlets].[GatewayType] = @GatewayType
        ORDER BY
            [idlets].[Network];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEnhancedTelemetryGetGatewaySettings';

