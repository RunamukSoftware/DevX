CREATE TABLE [Intesys].[SavedEventBeatTimeLog] (
    [SavedEventBeatTimeLogID] INT             IDENTITY (1, 1) NOT NULL,
    [PatientID]               INT             NOT NULL,
    [EventID]                 BIGINT          NOT NULL,
    [PatientStartDateTime]    DATETIME2 (7)   NOT NULL,
    [StartDateTime]           DATETIME2 (7)   NOT NULL,
    [NumberOfBeats]           INT             NOT NULL,
    [SampleRate]              SMALLINT        NOT NULL,
    [BeatData]                VARBINARY (MAX) NOT NULL,
    [CreatedDateTime]         DATETIME2 (7)   CONSTRAINT [DF_SavedEventBeatTimeLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_SavedEventBeatTimeLog_SavedEventBeatTimeLogID] PRIMARY KEY CLUSTERED ([SavedEventBeatTimeLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_SavedEventBeatTimeLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_SavedEventBeatTimeLog_PatientSavedEvent_PatientID_EventID] FOREIGN KEY ([PatientID], [EventID]) REFERENCES [Intesys].[PatientSavedEvent] ([PatientID], [EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_SavedEventBeatTimeLog_PatientID_EventID]
    ON [Intesys].[SavedEventBeatTimeLog]([PatientID] ASC, [EventID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'SavedEventBeatTimeLog';

