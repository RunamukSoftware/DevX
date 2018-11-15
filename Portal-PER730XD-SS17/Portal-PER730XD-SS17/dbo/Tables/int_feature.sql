CREATE TABLE [dbo].[int_feature] (
    [feature_cd] VARCHAR (25)  NOT NULL,
    [descr]      VARCHAR (120) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_feature_feature_cd]
    ON [dbo].[int_feature]([feature_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains a list of features the ICW product has. A product has many features. If no access was given to a product then all of the features in the product are turned off.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_feature';

