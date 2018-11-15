CREATE TABLE [Intesys].[CodeCategory] (
    [CodeCategoryID]  INT           IDENTITY (1, 1) NOT NULL,
    [CategoryCode]    CHAR (4)      NOT NULL,
    [CategoryName]    NVARCHAR (80) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_CodeCategory_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_CodeCategory_CodeCategoryID] PRIMARY KEY CLUSTERED ([CodeCategoryID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CodeCategory_CategoryCode]
    ON [Intesys].[CodeCategory]([CategoryCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the legal code categories used in the int_misc_code table. It is primarily a documentation tool, since very little logic requires these values. It is also used in System Administration. This table is pre-loaded with a set of rows that does not change for a given release.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'CodeCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code "category". This has the list of values used in the "cat_code" column in the int_misc_code table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'CodeCategory', @level2type = N'COLUMN', @level2name = N'CategoryCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description of the code category (how it is used).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'CodeCategory', @level2type = N'COLUMN', @level2name = N'CategoryName';

