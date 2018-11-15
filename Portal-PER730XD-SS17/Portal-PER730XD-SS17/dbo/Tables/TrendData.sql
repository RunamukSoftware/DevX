CREATE TABLE [dbo].[TrendData] (
    [user_id]            UNIQUEIDENTIFIER NOT NULL,
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [total_categories]   INT              NOT NULL,
    [start_ft]           BIGINT           NOT NULL,
    [total_periods]      INT              NOT NULL,
    [samples_per_period] INT              NOT NULL,
    [trend_data]         IMAGE            NULL,
    CONSTRAINT [PK_TrendData_user_id_patient_id] PRIMARY KEY CLUSTERED ([user_id] ASC, [patient_id] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_TrendData_AnalysisTime_user_id_patient_id] FOREIGN KEY ([user_id], [patient_id]) REFERENCES [dbo].[AnalysisTime] ([user_id], [patient_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains histogram information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TrendData';

