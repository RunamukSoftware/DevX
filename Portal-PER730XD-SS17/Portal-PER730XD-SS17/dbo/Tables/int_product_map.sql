CREATE TABLE [dbo].[int_product_map] (
    [product_cd] VARCHAR (25) NOT NULL,
    [feature_cd] VARCHAR (25) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_product_map_product_cd_feature_cd]
    ON [dbo].[int_product_map]([product_cd] ASC, [feature_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An associative table between the int_product table and the int_feature table. This table contains each feature within a given product. Each row is uniquely identified by the product_cd and feature_cd.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_product_map';

