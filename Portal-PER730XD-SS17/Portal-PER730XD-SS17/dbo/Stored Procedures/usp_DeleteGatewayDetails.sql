CREATE PROCEDURE [dbo].[usp_DeleteGatewayDetails]
    (
     @gatewayID UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [ig]
    FROM
        [dbo].[int_gateway] AS [ig]
    WHERE
        [gateway_id] = @gatewayID; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteGatewayDetails';

