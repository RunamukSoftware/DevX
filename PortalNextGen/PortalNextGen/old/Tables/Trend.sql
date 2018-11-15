CREATE TABLE [old].[Trend] (
    [UserID]           INT             NOT NULL,
    [PatientID]        INT             NOT NULL,
    [TotalCategories]  INT             NOT NULL,
    [StartDateTime]    INT             NOT NULL,
    [TotalPeriods]     INT             NOT NULL,
    [SamplesPerPeriod] INT             NOT NULL,
    [TrendData]        VARBINARY (MAX) NULL,
    [AnalysisTimeID]   INT             NOT NULL,
    [CreatedDateTime]  DATETIME2 (7)   CONSTRAINT [DF_Trend_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Trend_UserID_PatientID] PRIMARY KEY CLUSTERED ([UserID] ASC, [PatientID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Trend_AnalysisTime_AnalysisTimeID] FOREIGN KEY ([AnalysisTimeID]) REFERENCES [old].[AnalysisTime] ([AnalysisTimeID]),
    CONSTRAINT [FK_Trend_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_Trend_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains histogram information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'Trend';

