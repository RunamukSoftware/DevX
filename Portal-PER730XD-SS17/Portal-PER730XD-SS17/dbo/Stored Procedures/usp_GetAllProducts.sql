CREATE PROCEDURE [dbo].[usp_GetAllProducts]
AS
BEGIN
    SELECT
        [product_cd],
        [descr],
        [has_access]
    FROM
        [dbo].[int_product]
    ORDER BY
        [product_cd];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetAllProducts';

