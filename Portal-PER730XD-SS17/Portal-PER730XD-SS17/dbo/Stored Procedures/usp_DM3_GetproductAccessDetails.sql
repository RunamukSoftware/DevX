CREATE PROCEDURE [dbo].[usp_DM3_GetproductAccessDetails] (@Product NVARCHAR(30))
AS
BEGIN
    SELECT
        [product_cd],
        [organization_id],
        [license_no]
    FROM
        [dbo].[int_product_access]
    WHERE
        [product_cd] = @Product;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetproductAccessDetails';

