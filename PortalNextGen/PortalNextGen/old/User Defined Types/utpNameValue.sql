CREATE TYPE [old].[utpNameValue] AS TABLE (
    [LiveDataID]     INT           NOT NULL,
    [SetID]          INT           NOT NULL,
    [Name]           VARCHAR (25)  NOT NULL,
    [Value]          VARCHAR (25)  NULL,
    [FeedTypeID]     INT           NOT NULL,
    [TopicSessionID] INT           NOT NULL,
    [Timestamp]      DATETIME2 (7) NOT NULL);

