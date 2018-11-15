CREATE TABLE [old].[PacerSpikeLog] (
    [PacerSpikeLogID] INT             IDENTITY (1, 1) NOT NULL,
    [UserID]          INT             NOT NULL,
    [PatientID]       INT             NOT NULL,
    [SampleRate]      SMALLINT        NOT NULL,
    [StartDateTime]   DATETIME2 (7)   NOT NULL,
    [NumberOfSpikes]  INT             NOT NULL,
    [SpikeData]       VARBINARY (MAX) NOT NULL,
    [AnalysisTimeID]  INT             NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_PacerSpikeLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PacerSpikeLog_PacerSpikeLogID] PRIMARY KEY CLUSTERED ([PacerSpikeLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PacerSpikeLog_AnalysisTime_AnalysisTimeID] FOREIGN KEY ([AnalysisTimeID]) REFERENCES [old].[AnalysisTime] ([AnalysisTimeID]),
    CONSTRAINT [FK_PacerSpikeLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_PacerSpikeLog_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PacerSpikeLog_UserID_PatientID_SampleRate]
    ON [old].[PacerSpikeLog]([UserID] ASC, [PatientID] ASC, [SampleRate] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains pacer spike information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PacerSpikeLog';

