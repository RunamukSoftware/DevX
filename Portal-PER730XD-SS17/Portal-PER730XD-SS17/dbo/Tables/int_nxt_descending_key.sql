CREATE TABLE [dbo].[int_nxt_descending_key] (
    [tbl_name]    CHAR (30)  NOT NULL,
    [descend_key] INT        NOT NULL,
    [filler1]     CHAR (255) NOT NULL,
    [filler2]     CHAR (255) NOT NULL,
    [filler3]     CHAR (255) NOT NULL,
    [filler4]     CHAR (255) NOT NULL,
    [filler5]     CHAR (255) NOT NULL,
    [filler6]     CHAR (255) NOT NULL,
    [filler7]     CHAR (255) NOT NULL,
    [filler8]     CHAR (139) NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_nxt_descending_key_tbl_name]
    ON [dbo].[int_nxt_descending_key]([tbl_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to keep track of the next descending key. Certain tables use the concept of an descending key. Descending keys must be unique and always counting down. This table keeps track of the last one assigned. In general, the Clinical Browser has reduced its need on these types of keys since they are a single point of locks.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_nxt_descending_key';

