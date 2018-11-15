CREATE PROCEDURE [dbo].[usp_GatewayServerDetails]
    (
     @gatewayID UNIQUEIDENTIFIER,
     @serverName NVARCHAR(50),
     @port INT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_gateway_server]
            ([gateway_id],
             [server_name],
             [port]
            )
    VALUES
            (@gatewayID,
             @serverName,
             @port
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GatewayServerDetails';

