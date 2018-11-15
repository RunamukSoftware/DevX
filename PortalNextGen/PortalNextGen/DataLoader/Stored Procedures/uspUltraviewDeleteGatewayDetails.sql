CREATE PROCEDURE [DataLoader].[uspUltraviewDeleteGatewayDetails] (@GatewayID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [iduts]
        FROM
            [DataLoader].[UltraViewTemporarySettings] AS [iduts]
        WHERE
            [iduts].[GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DataLoader', @level1type = N'PROCEDURE', @level1name = N'uspUltraviewDeleteGatewayDetails';

