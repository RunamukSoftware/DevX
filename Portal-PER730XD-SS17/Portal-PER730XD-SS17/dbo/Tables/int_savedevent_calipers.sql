CREATE TABLE [dbo].[int_savedevent_calipers] (
    [patient_id]           UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]      UNIQUEIDENTIFIER NULL,
    [event_id]             UNIQUEIDENTIFIER NOT NULL,
    [channel_type]         INT              NOT NULL,
    [caliper_type]         INT              NOT NULL,
    [calipers_orientation] NCHAR (50)       NOT NULL,
    [caliper_text]         NVARCHAR (200)   NULL,
    [caliper_start_ms]     BIGINT           NOT NULL,
    [caliper_end_ms]       BIGINT           NOT NULL,
    [caliper_top]          INT              NOT NULL,
    [caliper_bottom]       INT              NOT NULL,
    [first_caliper_index]  INT              NULL,
    [second_caliper_index] INT              NULL,
    CONSTRAINT [PK_int_savedevent_calipers] PRIMARY KEY CLUSTERED ([patient_id] ASC, [event_id] ASC, [channel_type] ASC, [caliper_type] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_savedevent_calipers_int_savedevent_patient_id_event_id] FOREIGN KEY ([patient_id], [event_id]) REFERENCES [dbo].[int_SavedEvent] ([patient_id], [event_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_savedevent_calipers';

