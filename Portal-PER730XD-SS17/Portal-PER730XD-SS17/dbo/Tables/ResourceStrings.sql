CREATE TABLE [dbo].[ResourceStrings] (
    [Name]    NVARCHAR (250) NOT NULL,
    [Value]   NVARCHAR (250) NULL,
    [Comment] NVARCHAR (250) NULL,
    [Locale]  NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_ResourceStrings_Locale_Name] PRIMARY KEY CLUSTERED ([Locale] ASC, [Name] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ResourceStrings';

