CREATE PROCEDURE [old].[uspGatewayServerDetails]
    (
        @GatewayID  INT,
        @ServerName NVARCHAR(50),
        @Port       INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[GatewayServer]
            (
                [GatewayID],
                [ServerName],
                [Port]
            )
        VALUES
            (
                @GatewayID, @ServerName, @Port
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGatewayServerDetails';

