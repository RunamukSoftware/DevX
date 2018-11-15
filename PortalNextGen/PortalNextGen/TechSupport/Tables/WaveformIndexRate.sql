CREATE TABLE [TechSupport].[WaveformIndexRate] (
    [WaveformIndexRateID]  INT           IDENTITY (1, 1) NOT NULL,
    [WaveformRateIndex]    INT           NOT NULL,
    [CurrentWaveformCount] INT           NOT NULL,
    [ActiveWaveform]       INT           NOT NULL,
    [PeriodStartDateTime]  DATETIME2 (7) NOT NULL,
    [PeriodLength]         INT           NOT NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_WaveformIndexRate_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_TechSupport_WaveformIndexRate_WaveformIndexRateID] PRIMARY KEY CLUSTERED ([WaveformIndexRateID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tracks input rate per channel and can be used to evaluate problems with waveform collection', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'TABLE', @level1name = N'WaveformIndexRate';

