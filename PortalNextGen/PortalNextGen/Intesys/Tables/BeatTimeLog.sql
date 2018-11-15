CREATE TABLE [Intesys].[BeatTimeLog] (
    [BeatTimeLogID]   INT             IDENTITY (1, 1) NOT NULL,
    [UserID]          INT             NOT NULL,
    [PatientID]       INT             NOT NULL,
    [StartDateTime]   DATETIME2 (7)   NOT NULL,
    [NumberBeats]     INT             NOT NULL,
    [SampleRate]      SMALLINT        NOT NULL,
    [BeatData]        VARBINARY (MAX) NULL,
    [AnalysisTimeID]  INT             NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_BeatTimeLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_BeatTimeLog_BeatTimeLogID] PRIMARY KEY CLUSTERED ([BeatTimeLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_BeatTimeLog_AnalysisTime_AnalysisTimeID] FOREIGN KEY ([AnalysisTimeID]) REFERENCES [old].[AnalysisTime] ([AnalysisTimeID]),
    CONSTRAINT [FK_BeatTimeLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_BeatTimeLog_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BeatTimeLog_UserID_PatientID_SampleRate]
    ON [Intesys].[BeatTimeLog]([UserID] ASC, [PatientID] ASC, [SampleRate] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains beat time log information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'BeatTimeLog';

