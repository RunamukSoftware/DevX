CREATE TABLE [Intesys].[Waveform] (
    [WaveformID]        BIGINT          IDENTITY (-9223372036854775808, 1) NOT NULL,
    [OriginalPatientID] INT             NULL,
    [PatientChannelID]  INT             NOT NULL,
    [StartDateTime]     DATETIME2 (7)   NOT NULL,
    [EndDateTime]       DATETIME2 (7)   NULL,
    [CompressMethod]    CHAR (8)        NULL,
    [WaveformData]      VARBINARY (MAX) NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_Waveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Waveform_WaveformID] PRIMARY KEY CLUSTERED ([WaveformID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Waveform_PatientChannel_PatientChannelID] FOREIGN KEY ([PatientChannelID]) REFERENCES [Intesys].[PatientChannel] ([PatientChannelID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Waveform_EndDateTime_WaveformID]
    ON [Intesys].[Waveform]([EndDateTime] ASC, [WaveformID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the waveform data collected and stored over time. A waveform is uniquely identified by PatientID, PatientChannelID, and start_ft. Each row contains a pre-defined amount of waveform data. As new waveform data is collected, the new waveform data is appended to the end of the existing data block, until the pre-defined amount of data is reached. A new row is then created. The data in this table is populated by the MonitorLoader process.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Waveform';

