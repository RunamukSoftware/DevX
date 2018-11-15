CREATE TABLE [Intesys].[PrintJobEnhancedTelemetryWaveform] (
    [PrintJobEnhancedTelemetryWaveformID] INT             NOT NULL,
    [DeviceSessionID]                     INT             NOT NULL,
    [StartDateTime]                       DATETIME2 (7)   NOT NULL,
    [EndDateTime]                         DATETIME2 (7)   NOT NULL,
    [SampleRate]                          INT             NOT NULL,
    [WaveformData]                        VARBINARY (MAX) NOT NULL,
    [ChannelCode]                         INT             NOT NULL,
    [CdiLabel]                            VARCHAR (255)   NOT NULL,
    [CreatedDateTime]                     DATETIME2 (7)   CONSTRAINT [DF_PrintJobEnhancedTelemetryWaveform_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintJobEnhancedTelemetryWaveform_PrintJobEnhancedTelemetryWaveformID] PRIMARY KEY CLUSTERED ([PrintJobEnhancedTelemetryWaveformID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryWaveform_DeviceSession_DeviceSessionID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [old].[DeviceSession] ([DeviceSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryWaveform_DeviceSessionID_StartDateTime_EndDateTime_ChannelCode]
    ON [Intesys].[PrintJobEnhancedTelemetryWaveform]([DeviceSessionID] ASC, [StartDateTime] ASC, [EndDateTime] ASC, [ChannelCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PrintJobEnhancedTelemetryWaveform';

