CREATE TABLE [dbo].[int_beat_time_log] (
    [user_id]     UNIQUEIDENTIFIER NOT NULL,
    [patient_id]  UNIQUEIDENTIFIER NOT NULL,
    [start_ft]    BIGINT           NOT NULL,
    [num_beats]   INT              NOT NULL,
    [sample_rate] SMALLINT         NOT NULL,
    [beat_data]   IMAGE            NULL,
    CONSTRAINT [PK_int_beat_time_log_user_id_patient_id_sample_rate] PRIMARY KEY CLUSTERED ([user_id] ASC, [patient_id] ASC, [sample_rate] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_beat_time_log_AnalysisTime_user_id_patient_id] FOREIGN KEY ([user_id], [patient_id]) REFERENCES [dbo].[AnalysisTime] ([user_id], [patient_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains beat time log information (one row for each user/patient analysis)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_beat_time_log';

