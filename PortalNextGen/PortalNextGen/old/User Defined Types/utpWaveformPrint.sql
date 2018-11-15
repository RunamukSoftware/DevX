CREATE TYPE [old].[utpWaveformPrint] AS TABLE (
    [PrintRequestID] INT           NOT NULL,
    [ChannelIndex]   INT           NOT NULL,
    [NumSamples]     INT           NOT NULL,
    [Samples]        VARCHAR (MAX) NOT NULL);

