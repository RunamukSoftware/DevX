CREATE TABLE [old].[WaveformPrint] (
    [WaveformPrintID] INT           IDENTITY (1, 1) NOT NULL,
    [PrintRequestID]  INT           NOT NULL,
    [ChannelIndex]    INT           NOT NULL,
    [NumSamples]      INT           NOT NULL,
    [Samples]         VARCHAR (MAX) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_WaveformPrint_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_WaveformPrint_WaveformPrintID] PRIMARY KEY CLUSTERED ([WaveformPrintID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_WaveformPrint_PrintRequest_PrintRequestID] FOREIGN KEY ([PrintRequestID]) REFERENCES [old].[PrintRequest] ([PrintRequestID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Information for printing waveforms', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'WaveformPrint';

