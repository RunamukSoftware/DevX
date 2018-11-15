CREATE TABLE [Intesys].[ConfigurationValue] (
    [KeyName]         VARCHAR (40)  NOT NULL,
    [KeyValue]        VARCHAR (100) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_ConfigurationValue_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ConfigurationValue_KeyName] PRIMARY KEY CLUSTERED ([KeyName] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information about system''s configurations values.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ConfigurationValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Configuration parameter''s name', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ConfigurationValue', @level2type = N'COLUMN', @level2name = N'KeyName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Parameter''s value', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ConfigurationValue', @level2type = N'COLUMN', @level2name = N'KeyValue';

