CREATE TABLE [old].[AnalysisTime] (
    [AnalysisTimeID]  INT           IDENTITY (1, 1) NOT NULL,
    [UserID]          INT           NOT NULL,
    [PatientID]       INT           NOT NULL,
    [StartDateTime]   DATETIME2 (7) NOT NULL,
    [EndDateTime]     DATETIME2 (7) NULL,
    [AnalysisType]    INT           NOT NULL,
    [InsertDateTime]  DATETIME2 (7) CONSTRAINT [DF_AnalysisTime_InsertedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_AnalysisTime_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AnalysisTime_AnalysisTimeID] PRIMARY KEY CLUSTERED ([AnalysisTimeID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AnalysisTime_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains the start and end time of the analysis (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'AnalysisTime';

