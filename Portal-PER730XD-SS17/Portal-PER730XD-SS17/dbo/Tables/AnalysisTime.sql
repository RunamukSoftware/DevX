CREATE TABLE [dbo].[AnalysisTime] (
    [user_id]       UNIQUEIDENTIFIER NOT NULL,
    [patient_id]    UNIQUEIDENTIFIER NOT NULL,
    [start_ft]      BIGINT           NULL,
    [end_ft]        BIGINT           NULL,
    [analysis_type] INT              NOT NULL,
    [insert_dt]     DATETIME         CONSTRAINT [DEF_AnalysisTime_insert_dt] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AnalysisTime_user_id_patient_id] PRIMARY KEY CLUSTERED ([user_id] ASC, [patient_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains the start and end time of the analysis (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AnalysisTime';

