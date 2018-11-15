CREATE TABLE [Purger].[Log] (
    [LogID]           BIGINT         IDENTITY (-9223372036854775808, 1) NOT NULL,
    [Procedure]       NVARCHAR (128) NOT NULL,
    [Table]           NVARCHAR (128) NOT NULL,
    [PurgeDate]       DATETIME2 (7)  NOT NULL,
    [Parameters]      NVARCHAR (255) NOT NULL,
    [ChunkSize]       INT            NOT NULL,
    [Rows]            INT            NOT NULL,
    [ErrorNumber]     INT            NULL,
    [ErrorMessage]    NVARCHAR (MAX) NULL,
    [StartDateTime]   DATETIME2 (7)  CONSTRAINT [DF_Purger_Log_StartDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_Purger_Log_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Purger_Log_LogID] PRIMARY KEY CLUSTERED ([LogID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_Purger_Log_CreatedDateTime_LogID]
    ON [Purger].[Log]([CreatedDateTime] ASC, [LogID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purger log information.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'TABLE', @level1name = N'Log';

