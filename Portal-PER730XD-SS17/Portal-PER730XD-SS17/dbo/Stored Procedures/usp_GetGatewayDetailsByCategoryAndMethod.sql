CREATE PROCEDURE [dbo].[usp_GetGatewayDetailsByCategoryAndMethod]
AS
BEGIN
    SELECT
        [code_id],
        [organization_id],
        [sys_id],
        [category_cd],
        [method_cd],
        [code],
        [verification_sw],
        [int_keystone_cd],
        [short_dsc],
        [spc_pcs_code]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [category_cd] = 'USID'
        AND [method_cd] = N'GDS'
    ORDER BY
        [code];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetGatewayDetailsByCategoryAndMethod';

