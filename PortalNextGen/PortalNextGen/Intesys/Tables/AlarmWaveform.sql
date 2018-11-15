CREATE TABLE [Intesys].[AlarmWaveform] (
    [AlarmWaveformID] INT           IDENTITY (1, 1) NOT NULL,
    [AlarmID]         INT           NOT NULL,
    [Retrieved]       TINYINT       NOT NULL,
    [SequenceNumber]  INT           NOT NULL,
    [WaveformData]    VARCHAR (MAX) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_AlarmWaveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AlarmWaveform_AlarmWaveformID] PRIMARY KEY CLUSTERED ([AlarmWaveformID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlarmWaveform_AlarmID_SequenceNumber]
    ON [Intesys].[AlarmWaveform]([AlarmID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_AlarmWaveform_CreatedDateTime]
    ON [Intesys].[AlarmWaveform]([CreatedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the raw waveform data of the alarm event (ECG). It refers to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the int_alarm_event table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform', @level2type = N'COLUMN', @level2name = N'AlarmID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - not retrieved 1 - retrieved.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform', @level2type = N'COLUMN', @level2name = N'Retrieved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequential number of the data: 1, 2', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform', @level2type = N'COLUMN', @level2name = N'SequenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Raw waveform data is stored here. It is in an unprocessed state from the monitor.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform', @level2type = N'COLUMN', @level2name = N'WaveformData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the alarm data was taken.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AlarmWaveform', @level2type = N'COLUMN', @level2name = N'CreatedDateTime';

