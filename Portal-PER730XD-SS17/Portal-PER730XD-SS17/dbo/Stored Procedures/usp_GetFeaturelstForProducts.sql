CREATE PROCEDURE [dbo].[usp_GetFeaturelstForProducts]
AS
BEGIN
    SELECT
        [int_product_map].[product_cd],
        [int_feature].[feature_cd],
        [int_feature].[descr] AS [feature_descr]
    FROM
        [dbo].[int_product_map]
        INNER JOIN [dbo].[int_feature] ON [int_product_map].[feature_cd] = [int_feature].[feature_cd];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetFeaturelstForProducts';

