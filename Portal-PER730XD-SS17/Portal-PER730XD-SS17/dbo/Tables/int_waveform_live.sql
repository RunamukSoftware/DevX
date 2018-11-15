CREATE TABLE [dbo].[int_waveform_live] (
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]    UNIQUEIDENTIFIER NULL,
    [patient_channel_id] UNIQUEIDENTIFIER NOT NULL,
    [start_dt]           DATETIME         NOT NULL,
    [end_dt]             DATETIME         NULL,
    [start_ft]           BIGINT           NULL,
    [end_ft]             BIGINT           NULL,
    [compress_method]    CHAR (8)         NULL,
    [waveform_data]      IMAGE            NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_waveform_live_patient_id_patient_channel_id]
    ON [dbo].[int_waveform_live]([patient_id] ASC, [patient_channel_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the waveform data for a given patient and channel. Each patient_id, channel_id row will be unique. When new data comes in for a patient on a channel the waveform_data is updated. A new record is NOT inserted.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_waveform_live';

