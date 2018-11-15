CREATE TABLE [old].[AnalysisEvent] (
    [AnalysisEventID] INT             IDENTITY (1, 1) NOT NULL,
    [PatientID]       INT             NOT NULL,
    [UserID]          INT             NOT NULL,
    [Type]            INT             NOT NULL,
    [NumberOfEvents]  INT             NOT NULL,
    [SampleRate]      SMALLINT        NOT NULL,
    [EventData]       VARBINARY (MAX) NULL,
    [AnalysisTimeID]  INT             NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_AnalysisEvent_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AnalysisEvent_AnalysisEventID] PRIMARY KEY CLUSTERED ([AnalysisEventID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AnalysisEvent_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_AnalysisEvent_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID]),
    CONSTRAINT [FK_AnalysisEvents_AnalysisTime_AnalysisTimeID] FOREIGN KEY ([AnalysisTimeID]) REFERENCES [old].[AnalysisTime] ([AnalysisTimeID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains arrhythmia events. Has additional PK of ''Type'' because it contains one row for each Type of event for that analysis', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'AnalysisEvent';

