CREATE TABLE [dbo].[int_savedevent_beat_time_log] (
    [patient_id]       UNIQUEIDENTIFIER NOT NULL,
    [event_id]         UNIQUEIDENTIFIER NOT NULL,
    [patient_start_ft] BIGINT           NOT NULL,
    [start_ft]         BIGINT           NOT NULL,
    [num_beats]        INT              NOT NULL,
    [sample_rate]      SMALLINT         NOT NULL,
    [beat_data]        IMAGE            NOT NULL,
    CONSTRAINT [PK_int_savedevent_beat_time_log] PRIMARY KEY CLUSTERED ([patient_id] ASC, [event_id] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_savedevent_beat_time_log_int_savedevent_patient_id_event_id] FOREIGN KEY ([patient_id], [event_id]) REFERENCES [dbo].[int_SavedEvent] ([patient_id], [event_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_savedevent_beat_time_log';

