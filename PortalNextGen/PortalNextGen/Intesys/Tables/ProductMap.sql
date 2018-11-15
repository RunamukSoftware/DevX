CREATE TABLE [Intesys].[ProductMap] (
    [ProductMapID]    INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]       INT           NOT NULL,
    [FeatureID]       INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_ProductMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ProductMap_ProductMapID] PRIMARY KEY CLUSTERED ([ProductMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_ProductMap_Feature_FeatureID] FOREIGN KEY ([FeatureID]) REFERENCES [Intesys].[Feature] ([FeatureID]),
    CONSTRAINT [FK_ProductMap_Product_ProductID] FOREIGN KEY ([ProductID]) REFERENCES [Intesys].[Product] ([ProductID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductMap_ProductCode_FeatureCode]
    ON [Intesys].[ProductMap]([ProductID] ASC, [FeatureID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An associative table between the int_product table and the int_feature table. This table contains each feature within a given product. Each row is uniquely identified by the productCode and featureCode.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ProductMap';

