CREATE TYPE [old].[utpWaveformAnnotation] AS TABLE (
    [WaveformAnnotationID] INT           NOT NULL,
    [PrintRequestID]       INT           NOT NULL,
    [ChannelIndex]         INT           NOT NULL,
    [Annotation]           VARCHAR (MAX) NOT NULL);

