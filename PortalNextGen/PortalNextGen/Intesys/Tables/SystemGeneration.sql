CREATE TABLE [Intesys].[SystemGeneration] (
    [SystemGenerationID] INT           IDENTITY (1, 1) NOT NULL,
    [ProductCode]        VARCHAR (25)  NOT NULL,
    [FeatureCode]        VARCHAR (25)  NOT NULL,
    [Setting]            VARCHAR (80)  NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_SystemGeneration_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SystemGeneration_SystemGenerationID] PRIMARY KEY CLUSTERED ([SystemGenerationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the system generation information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SystemGeneration';

