CREATE TABLE [dbo].[int_alarm_waveform] (
    [alarm_id]      UNIQUEIDENTIFIER NOT NULL,
    [retrieved]     TINYINT          NULL,
    [waveform_data] TEXT             NULL,
    [seq_num]       INT              NOT NULL,
    [insert_dt]     DATETIME         NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_alarm_waveform_alarm_id_seq_num]
    ON [dbo].[int_alarm_waveform]([alarm_id] ASC, [seq_num] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_alarm_waveform_insert_dt]
    ON [dbo].[int_alarm_waveform]([insert_dt] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the raw waveform data of the alarm event (ECG). It refers to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform', @level2type = N'COLUMN', @level2name = N'alarm_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - not retrieved 1 - retrieved.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform', @level2type = N'COLUMN', @level2name = N'retrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Raw waveform data is stored here. It is in an unprocessed state from the monitor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform', @level2type = N'COLUMN', @level2name = N'waveform_data';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequential number of the data: 1, 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform', @level2type = N'COLUMN', @level2name = N'seq_num';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the alarm data was taken.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm_waveform', @level2type = N'COLUMN', @level2name = N'insert_dt';

