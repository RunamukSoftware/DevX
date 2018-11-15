CREATE TABLE [Configuration].[ValueUnit] (
    [ValueUnitID]           INT             IDENTITY (1, 1) NOT NULL,
    [UnitID]                INT             NOT NULL,
    [TypeCode]              VARCHAR (25)    NOT NULL,
    [ConfigurationName]     VARCHAR (40)    NOT NULL,
    [ConfigurationValue]    NVARCHAR (1800) NULL,
    [ConfigurationXmlValue] XML             NULL,
    [ValueType]             VARCHAR (20)    NOT NULL,
    [CreatedDateTime]       DATETIME2 (7)   CONSTRAINT [DF_ValueUnit_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ValueUnit_ValueUnitID] PRIMARY KEY CLUSTERED ([ValueUnitID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_ValueUnit_ValueUnitID]
    ON [Configuration].[ValueUnit]([UnitID] ASC, [TypeCode] ASC, [ConfigurationName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains CH unit settings (gets populated if user goes into ICS Admin and modifies settings for a given unit). TypeCode, ConfigurationName, and UnitID should be PKs.', @level0type = N'SCHEMA', @level0name = N'Configuration', @level1type = N'TABLE', @level1name = N'ValueUnit';

