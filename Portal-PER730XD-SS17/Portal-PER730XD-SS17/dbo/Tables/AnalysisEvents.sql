CREATE TABLE [dbo].[AnalysisEvents] (
    [patient_id]  UNIQUEIDENTIFIER NOT NULL,
    [user_id]     UNIQUEIDENTIFIER NOT NULL,
    [type]        INT              NOT NULL,
    [num_events]  INT              NOT NULL,
    [sample_rate] SMALLINT         NOT NULL,
    [event_data]  IMAGE            NULL,
    CONSTRAINT [PK_AnalysisEvents_patient_id_user_id_type] PRIMARY KEY CLUSTERED ([patient_id] ASC, [user_id] ASC, [type] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AnalysisEvents_AnalysisTime_user_id_patient_id] FOREIGN KEY ([user_id], [patient_id]) REFERENCES [dbo].[AnalysisTime] ([user_id], [patient_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains arrhythmia events. Has additional PK of ''type'' because it contains one row for each type of event for that analysis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AnalysisEvents';

