CREATE PROCEDURE [dbo].[usp_DL_UV_DeleteGatewayDetails]
    (
     @gatewayID UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [iduts]
    FROM
        [dbo].[int_DataLoader_UV_Temp_Settings] AS [iduts]
    WHERE
        [gateway_id] = @gatewayID; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_UV_DeleteGatewayDetails';

