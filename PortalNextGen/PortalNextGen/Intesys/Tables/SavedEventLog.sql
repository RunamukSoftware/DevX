CREATE TABLE [Intesys].[SavedEventLog] (
    [SavedEventLogID]     BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [PatientID]           INT           NOT NULL,
    [OriginalPatientID]   INT           NULL,
    [EventID]             BIGINT        NOT NULL,
    [PrimaryChannel]      BIT           NOT NULL,
    [TimeTagType]         INT           NOT NULL,
    [LeadType]            INT           NOT NULL,
    [MonitorEventType]    INT           NOT NULL,
    [ArrhythmiaEventType] INT           NOT NULL,
    [start_ms]            INT           NOT NULL,
    [end_ms]              INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_SavedEventLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SavedEventLog_SavedEventLogID] PRIMARY KEY CLUSTERED ([SavedEventLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SavedEventLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_SavedEventLog_PatientID_EventID] FOREIGN KEY ([PatientID], [EventID]) REFERENCES [Intesys].[PatientSavedEvent] ([PatientID], [EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SavedEventLog_PatientID_EventID]
    ON [Intesys].[SavedEventLog]([PatientID] ASC, [EventID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is designed to save savedevent lead changes and monitor events logs (lead changed log timetag_type = 12289   monitor event log timetag_type = 12290)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by lead change log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'PrimaryChannel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by lead change and monitor events log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'TimeTagType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by lead change log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'LeadType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by monitor event log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'MonitorEventType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by lead change and monitor event log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'start_ms';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by monitor event log', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventLog', @level2type = N'COLUMN', @level2name = N'end_ms';

