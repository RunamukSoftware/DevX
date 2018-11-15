CREATE TABLE [dbo].[int_saved_event_waveform] (
    [patient_id]        UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]   UNIQUEIDENTIFIER NULL,
    [event_id]          INT              NOT NULL,
    [wave_index]        INT              NOT NULL,
    [waveform_category] INT              NOT NULL,
    [lead]              INT              NOT NULL,
    [resolution]        INT              NOT NULL,
    [height]            INT              NOT NULL,
    [waveform_type]     INT              NOT NULL,
    [visible]           TINYINT          NOT NULL,
    [scale]             FLOAT (53)       NOT NULL,
    [scale_units]       INT              NOT NULL,
    [scale_min]         INT              NOT NULL,
    [scale_max]         INT              NOT NULL,
    [duration]          INT              NOT NULL,
    [sample_rate]       INT              NOT NULL,
    [sample_count]      INT              NOT NULL,
    [num_Ypoints]       INT              NOT NULL,
    [baseline]          INT              NOT NULL,
    [Ypoints_per_unit]  FLOAT (53)       NOT NULL,
    [waveform_data]     IMAGE            NULL,
    [num_timelogs]      INT              NOT NULL,
    [timelog_data]      IMAGE            NULL,
    [Sequence]          BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL
);
GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_saved_event_waveform_patient_id_event_id_wave_index]
    ON [dbo].[int_saved_event_waveform]([patient_id] ASC, [event_id] ASC, [wave_index] ASC) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores base waveform information, raw waveform data, and timelog data for each waveform within a saved event. Each record is uniquely identified by event_id and wave_index. The data in this table is populated by the Patsrvr process.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_saved_event_waveform';
