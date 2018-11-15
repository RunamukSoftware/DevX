CREATE TABLE [Configuration].[ValueGlobal] (
    [ValueGlobalID]         INT             IDENTITY (1, 1) NOT NULL,
    [TypeCode]              VARCHAR (25)    NOT NULL,
    [ConfigurationName]     VARCHAR (40)    NOT NULL,
    [ConfigurationValue]    NVARCHAR (1800) NULL,
    [ConfigurationXmlValue] XML             NULL,
    [ValueType]             VARCHAR (20)    NOT NULL,
    [GlobalType]            BIT             NOT NULL,
    [CreatedDateTime]       DATETIME2 (7)   CONSTRAINT [DF_ValueGlobal_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ValueGlobal_ValueGlobalID] PRIMARY KEY CLUSTERED ([ValueGlobalID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ValueGlobal_TypeCode_ConfigurationName]
    ON [Configuration].[ValueGlobal]([TypeCode] ASC, [ConfigurationName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains global CH settings (gets populated if user goes into ICS Admin and overwrites factory defaults). TypeCode and ConfigurationName should be PKs.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'ValueGlobal';

