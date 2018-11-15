CREATE TABLE [dbo].[int_waveform] (
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]    UNIQUEIDENTIFIER NULL,
    [patient_channel_id] UNIQUEIDENTIFIER NOT NULL,
    [start_dt]           DATETIME         NOT NULL,
    [end_dt]             DATETIME         NULL,
    [start_ft]           BIGINT           NOT NULL,
    [end_ft]             BIGINT           NOT NULL,
    [compress_method]    CHAR (8)         NULL,
    [waveform_data]      IMAGE            NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_waveform_patient_id_patient_channel_id_start_ft_end_ft]
    ON [dbo].[int_waveform]([patient_id] ASC, [patient_channel_id] ASC, [start_ft] ASC, [end_ft] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_waveform_patient_channel_id_start_ft_end_ft]
    ON [dbo].[int_waveform]([patient_channel_id] ASC, [start_ft] ASC, [end_ft] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_waveform_end_ft]
    ON [dbo].[int_waveform]([end_dt] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_waveform_patient_id_start_ft_end_ft]
    ON [dbo].[int_waveform]([patient_id] ASC, [end_ft] ASC, [start_ft] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_waveform_patient_id_start_ft_patient_channel_id_start_dt_end_ft]
    ON [dbo].[int_waveform]([patient_id] ASC, [start_ft] ASC)
    INCLUDE([patient_channel_id], [start_dt], [end_ft]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the waveform data collected and stored over time. A waveform is uniquely identified by patient_id, patient_channel_id, and start_ft. Each row contains a pre-defined amount of waveform data. As new waveform data is collected, the new waveform data is appended to the end of the existing data block, until the pre-defined amount of data is reached. A new row is then created. The data in this table is populated by the MonitorLoader process.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_waveform';

