CREATE TYPE [dbo].[WaveformPrintDataType] AS TABLE (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [ChannelIndex]   INT              NOT NULL,
    [NumSamples]     INT              NOT NULL,
    [Samples]        VARCHAR (MAX)    NOT NULL);

