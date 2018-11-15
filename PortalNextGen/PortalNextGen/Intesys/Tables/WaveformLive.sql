CREATE TABLE [Intesys].[WaveformLive] (
    [WaveformLiveID]    BIGINT          IDENTITY (-9223372036854775808, 1) NOT NULL,
    [PatientID]         INT             NOT NULL,
    [OriginalPatientID] INT             NULL,
    [PatientChannelID]  INT             NOT NULL,
    [StartDateTime]     DATETIME2 (7)   NOT NULL,
    [EndDateTime]       DATETIME2 (7)   NULL,
    [CompressMethod]    CHAR (8)        NULL,
    [WaveformData]      VARBINARY (MAX) NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_WaveformLive_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformLive_WaveformLiveID] PRIMARY KEY CLUSTERED ([WaveformLiveID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_WaveformLive_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_WaveformLive_PatientChannel_PatientChannelID] FOREIGN KEY ([PatientChannelID]) REFERENCES [Intesys].[PatientChannel] ([PatientChannelID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WaveformLive_PatientID_PatientChannelID]
    ON [Intesys].[WaveformLive]([PatientID] ASC, [PatientChannelID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains the waveform data for a given patient and channel. Each PatientID, channelID row will be unique. When new data comes in for a patient on a channel the WaveformData is updated. A new record is NOT inserted.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'WaveformLive';

