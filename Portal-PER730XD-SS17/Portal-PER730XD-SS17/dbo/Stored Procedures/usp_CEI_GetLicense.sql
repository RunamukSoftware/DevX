CREATE PROCEDURE [dbo].[usp_CEI_GetLicense]
AS
BEGIN
    SELECT
        [product_cd]
    FROM
        [dbo].[int_product_access]
    WHERE
        [product_cd] = 'cei';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetLicense';

