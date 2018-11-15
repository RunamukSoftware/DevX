CREATE TABLE [dbo].[RemovedAlarms] (
    [AlarmId] UNIQUEIDENTIFIER NOT NULL,
    [Removed] TINYINT          NULL,
    [CreatedDateTime] DATETIME2(7) NOT NULL CONSTRAINT [DF_RemovedAlarms_CreatedDateTime] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_RemovedAlarms_AlarmId] PRIMARY KEY CLUSTERED ([AlarmId] ASC) WITH (FILLFACTOR = 100)
);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RemovedAlarms';

