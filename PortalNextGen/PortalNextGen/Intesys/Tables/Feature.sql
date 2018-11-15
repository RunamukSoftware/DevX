CREATE TABLE [Intesys].[Feature] (
    [FeatureID]       INT           IDENTITY (1, 1) NOT NULL,
    [FeatureCode]     VARCHAR (25)  NOT NULL,
    [Description]     VARCHAR (120) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Feature_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Feature_FeatureID] PRIMARY KEY CLUSTERED ([FeatureID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Feature_FeatureCode]
    ON [Intesys].[Feature]([FeatureCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains a list of features the ICW product has. A product has many features. If no access was given to a product then all of the features in the product are turned off.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Feature';

