CREATE TABLE [dbo].[int_product] (
    [product_cd] VARCHAR (25)  NOT NULL,
    [descr]      VARCHAR (120) NULL,
    [has_access] SMALLINT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_product_product_cd]
    ON [dbo].[int_product]([product_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data containing the product codes used in the ICW product suite. A product contains features that can be turned on an off. Each record is uniquely identified by the product_cd.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_product';

