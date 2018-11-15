CREATE PROCEDURE [dbo].[usp_CEI_GetLicenseUnits]
AS
BEGIN
    SELECT
        [int_organization].[organization_cd]
    FROM
        [dbo].[int_organization]
        INNER JOIN [dbo].[int_product_access] ON [int_organization].[organization_id] = [int_product_access].[organization_id]
    WHERE
        [int_product_access].[product_cd] = 'cei';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetLicenseUnits';

