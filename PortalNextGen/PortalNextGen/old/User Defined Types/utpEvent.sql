CREATE TYPE [old].[utpEvent] AS TABLE (
    [CategoryValue]  INT           NOT NULL,
    [Type]           INT           NOT NULL,
    [Subtype]        INT           NOT NULL,
    [Value1]         REAL          NOT NULL,
    [Value2]         REAL          NOT NULL,
    [Status]         INT           NOT NULL,
    [Valid_Leads]    INT           NOT NULL,
    [TopicSessionID] INT           NOT NULL,
    [FeedTypeID]     INT           NOT NULL,
    [Timestamp]      DATETIME2 (7) NOT NULL);

