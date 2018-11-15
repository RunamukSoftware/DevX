CREATE TABLE [Configuration].[Configuration] (
    [ConfigurationID] INT            IDENTITY (1, 1) NOT NULL,
    [ApplicationName] NVARCHAR (256) NOT NULL,
    [SectionName]     NVARCHAR (150) NOT NULL,
    [SectionData]     XML            NULL,
    [UpdatedDateTime] DATETIME2 (7)  NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_Configuration_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Configuration_ConfigurationID] PRIMARY KEY CLUSTERED ([ConfigurationID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'Configuration';

