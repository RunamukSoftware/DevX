CREATE TYPE [old].[utpWaveform] AS TABLE (
    [SampleCount]    INT             NOT NULL,
    [TypeName]       VARCHAR (50)    NULL,
    [TypeID]         INT             NULL,
    [Samples]        VARBINARY (MAX) NOT NULL,
    [Compressed]     BIT             NOT NULL,
    [TopicSessionID] INT             NOT NULL,
    [StartDateTime]  DATETIME2 (7)   NOT NULL,
    [EndDateTime]    DATETIME2 (7)   NOT NULL);

