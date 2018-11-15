CREATE TABLE [Configuration].[ValueFactory] (
    [ValueFactoryID]        INT             IDENTITY (1, 1) NOT NULL,
    [TypeCode]              VARCHAR (25)    NOT NULL,
    [ConfigurationName]     VARCHAR (40)    NOT NULL,
    [ConfigurationValue]    NVARCHAR (1800) NULL,
    [ConfigurationXmlValue] XML             NULL,
    [ValueType]             VARCHAR (20)    NOT NULL,
    [GlobalType]            BIT             NOT NULL,
    [CreatedDateTime]       DATETIME2 (7)   CONSTRAINT [DF_ValueFactory_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ValueFactory_ValueFactoryID] PRIMARY KEY CLUSTERED ([ValueFactoryID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_ValuesFactory_TypeCode_ConfigurationName]
    ON [Configuration].[ValueFactory]([TypeCode] ASC, [ConfigurationName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains factory defaults for CH settings. ', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'ValueFactory';

