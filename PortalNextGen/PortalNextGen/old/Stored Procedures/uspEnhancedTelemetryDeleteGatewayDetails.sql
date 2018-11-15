CREATE PROCEDURE [old].[uspEnhancedTelemetryDeleteGatewayDetails] (@GatewayID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [idets]
        FROM
            [DataLoader].[EnhancedTelemetryTemporarySettings] AS [idets]
        WHERE
            [idets].[GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspEnhancedTelemetryDeleteGatewayDetails';

