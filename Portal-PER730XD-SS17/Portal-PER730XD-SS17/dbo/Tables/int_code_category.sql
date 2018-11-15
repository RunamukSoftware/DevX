CREATE TABLE [dbo].[int_code_category] (
    [cat_code] CHAR (4)      NOT NULL,
    [cat_name] NVARCHAR (80) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_code_category_cat_code]
    ON [dbo].[int_code_category]([cat_code] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the legal code categories used in the int_misc_code table. It is primarily a documentation tool, since very little logic requires these values. It is also used in System Administration. This table is pre-loaded with a set of rows that does not change for a given release.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_code_category';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code "category". This has the list of values used in the "cat_code" column in the int_misc_code table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_code_category', @level2type = N'COLUMN', @level2name = N'cat_code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A description of the code category (how it is used).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_code_category', @level2type = N'COLUMN', @level2name = N'cat_name';

