CREATE TABLE [dbo].[ml_duplicate_info] (
    [Original_ID]       VARCHAR (20) NOT NULL,
    [Duplicate_Id]      VARCHAR (20) NOT NULL,
    [Original_Monitor]  VARCHAR (5)  NOT NULL,
    [Duplicate_Monitor] VARCHAR (5)  NOT NULL,
    [InsertDT]          DATETIME     CONSTRAINT [DEF_ml_duplicate_info_InsertDT] DEFAULT (getdate()) NOT NULL,
    [duplicate_rec_id]  BIGINT       IDENTITY (0, 1) NOT FOR REPLICATION NOT NULL,
    CONSTRAINT [PK_ml_duplicate_info] PRIMARY KEY CLUSTERED ([Original_ID] ASC, [Duplicate_Id] ASC, [Original_Monitor] ASC, [Duplicate_Monitor] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ml_duplicate_info';

