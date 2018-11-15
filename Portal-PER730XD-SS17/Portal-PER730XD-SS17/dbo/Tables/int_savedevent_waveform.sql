CREATE TABLE [dbo].[int_savedevent_waveform] (
    [patient_id]        UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]   UNIQUEIDENTIFIER NULL,
    [event_id]          UNIQUEIDENTIFIER NOT NULL,
    [wave_index]        INT              NOT NULL,
    [waveform_category] INT              NOT NULL,
    [lead]              INT              NOT NULL,
    [resolution]        INT              NOT NULL,
    [height]            INT              NOT NULL,
    [waveform_type]     INT              NOT NULL,
    [visible]           TINYINT          NOT NULL,
    [channel_id]        UNIQUEIDENTIFIER NOT NULL,
    [scale]             FLOAT (53)       NOT NULL,
    [scale_type]        INT              NOT NULL,
    [scale_min]         INT              NOT NULL,
    [scale_max]         INT              NOT NULL,
    [scale_unit_type]   INT              NOT NULL,
    [duration]          INT              NOT NULL,
    [sample_rate]       INT              NOT NULL,
    [sample_count]      BIGINT           NOT NULL,
    [num_Ypoints]       INT              NOT NULL,
    [baseline]          INT              NOT NULL,
    [Ypoints_per_unit]  FLOAT (53)       NOT NULL,
    [waveform_data]     IMAGE            NULL,
    [num_timelogs]      INT              NOT NULL,
    [timelog_data]      IMAGE            NULL,
    [waveform_color]    VARCHAR (50)     NULL,
    [Sequence]          BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    CONSTRAINT [PK_int_savedevent_waveform_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_savedevent_waveform_int_savedevent_patient_id_event_id] FOREIGN KEY ([patient_id], [event_id]) REFERENCES [dbo].[int_SavedEvent] ([patient_id], [event_id]) ON DELETE CASCADE
);
GO
CREATE NONCLUSTERED INDEX [IX_int_savedevent_waveform_patient_id_event_id]
    ON [dbo].[int_savedevent_waveform]([patient_id] ASC, [event_id] ASC) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains waveform data for a given saved event. It should have patient_id, event_id, and wave_index as PKs. The event_id column corresponds to the event_id column in the SavedEvent table. There can be several rows in this table for a given saved event (one for each waveform in the saved event).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_savedevent_waveform';
