CREATE TABLE [old].[RemovedAlarm] (
    [RemovedAlarmID]  INT           IDENTITY (1, 1) NOT NULL,
    [AlarmID]         INT           NOT NULL,
    [RemovedFlag]     TINYINT       NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_RemovedAlarm_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_RemovedAlarm_RemovedAlarmID] PRIMARY KEY CLUSTERED ([RemovedAlarmID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_RemovedAlarm_AlarmID]
    ON [old].[RemovedAlarm]([AlarmID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'RemovedAlarm';

