CREATE PROCEDURE [dbo].[usp_DL_ETR_DeleteGatewayDetails]
    (
     @gatewayID UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [idets]
    FROM
        [dbo].[int_DataLoader_ETR_Temp_Settings] AS [idets]
    WHERE
        [gateway_id] = @gatewayID; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DL_ETR_DeleteGatewayDetails';

