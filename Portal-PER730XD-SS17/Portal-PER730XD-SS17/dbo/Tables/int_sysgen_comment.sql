CREATE TABLE [dbo].[int_sysgen_comment] (
    [Sequence]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [comment_dt] DATETIME      NOT NULL,
    [comment]    VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_int_sysgen_comment_Sequence] PRIMARY KEY NONCLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores comments about system generation.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_sysgen_comment';

