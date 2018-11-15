CREATE TABLE [dbo].[WaveformPrintData] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [ChannelIndex]   INT              NOT NULL,
    [NumSamples]     INT              NOT NULL,
    [Samples]        VARCHAR (MAX)    NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Information for printing waveforms', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'WaveformPrintData';

