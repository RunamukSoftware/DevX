CREATE TABLE [Intesys].[Product] (
    [ProductID]       INT           IDENTITY (1, 1) NOT NULL,
    [ProductCode]     VARCHAR (25)  NOT NULL,
    [Description]     VARCHAR (120) NULL,
    [HasAccess]       SMALLINT      NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Product_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED ([ProductID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Product_ProductCode]
    ON [Intesys].[Product]([ProductCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data containing the product codes used in the ICW product suite. A product contains features that can be turned on an off. Each record is uniquely identified by the product code.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Product';

