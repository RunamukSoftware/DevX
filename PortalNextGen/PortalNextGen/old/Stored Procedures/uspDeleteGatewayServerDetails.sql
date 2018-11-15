CREATE PROCEDURE [old].[uspDeleteGatewayServerDetails] (@GatewayID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Intesys].[GatewayServer]
        WHERE
            [GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteGatewayServerDetails';

