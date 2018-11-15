CREATE PROCEDURE [old].[uspDeleteGatewayDetails] (@GatewayID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ig]
        FROM
            [Intesys].[Gateway] AS [ig]
        WHERE
            [ig].[GatewayID] = @GatewayID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteGatewayDetails';

