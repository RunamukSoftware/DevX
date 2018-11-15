CREATE TYPE [old].[utpPrintRequestEntry] AS TABLE (
    [PrintRequestID]       INT           NOT NULL,
    [PrintJobID]           INT           NOT NULL,
    [TopicSessionID]       INT           NOT NULL,
    [FeedTypeID]           INT           NOT NULL,
    [RequestTypeEnumID]    INT           NOT NULL,
    [RequestTypeEnumValue] INT           NOT NULL,
    [Timestamp]            DATETIME2 (7) NOT NULL);

