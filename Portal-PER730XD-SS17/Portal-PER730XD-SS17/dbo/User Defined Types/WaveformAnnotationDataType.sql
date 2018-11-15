CREATE TYPE [dbo].[WaveformAnnotationDataType] AS TABLE (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [ChannelIndex]   INT              NOT NULL,
    [Annotation]     VARCHAR (MAX)    NOT NULL);

