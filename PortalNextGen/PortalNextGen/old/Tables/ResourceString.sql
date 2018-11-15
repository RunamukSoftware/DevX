CREATE TABLE [old].[ResourceString] (
    [ResourceStringID] INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (250) NOT NULL,
    [Value]            NVARCHAR (250) NULL,
    [Comment]          NVARCHAR (250) NULL,
    [Locale]           NVARCHAR (50)  NOT NULL,
    [CreatedDateTime]  DATETIME2 (7)  CONSTRAINT [DF_ResourceString_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ResourceString_ResourceStringID] PRIMARY KEY CLUSTERED ([ResourceStringID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_ResourceString_Locale_Name]
    ON [old].[ResourceString]([Locale] ASC, [Name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'ResourceString';

