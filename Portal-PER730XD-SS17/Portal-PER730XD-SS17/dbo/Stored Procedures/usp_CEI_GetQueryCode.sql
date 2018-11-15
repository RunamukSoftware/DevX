CREATE PROCEDURE [dbo].[usp_CEI_GetQueryCode]
AS
BEGIN
    SELECT
        [code_id],
        [short_dsc],
        [int_keystone_cd]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [int_misc_code].[method_cd] = N'GDS'
        AND [int_misc_code].[verification_sw] IS NOT NULL
        AND [short_dsc] IS NOT NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetQueryCode';

