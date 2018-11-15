CREATE TABLE [dbo].[JunkTable] (
    [Column01] UNIQUEIDENTIFIER NOT NULL,
    [Column02] TINYINT          NULL,
    [Column03] DATETIME         NOT NULL,
    [Column04] DATETIME         NULL,
    [Column05] INT              NOT NULL,
    [Column06] INT              NOT NULL,
    [Column07] DATETIME         NOT NULL,
    [Column08] INT              NOT NULL,
    [Column09] UNIQUEIDENTIFIER NOT NULL,
    [Column10] UNIQUEIDENTIFIER NOT NULL,
    [Column11] UNIQUEIDENTIFIER NOT NULL,
    [Column12] INT              NOT NULL,
    [Column13] UNIQUEIDENTIFIER NOT NULL,
    [Column14] BIGINT           NOT NULL,
    [Column15] DATETIME2 (7)    NOT NULL,
    [Sequence]       BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    CONSTRAINT [PK_JunkTable_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);

