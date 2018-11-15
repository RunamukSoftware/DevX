CREATE TABLE [dbo].[int_translate_list] (
    [list_id]      UNIQUEIDENTIFIER NOT NULL,
    [translate_cd] VARCHAR (40)     NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_translate_list_list_id_translate_cd]
    ON [dbo].[int_translate_list]([list_id] ASC, [translate_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is a temporary table used to pass data from a given web page to the editor used to edit tags. You can truncate this table at any time (that language tags are not being edited).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_translate_list';

