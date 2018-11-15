CREATE TYPE [old].[utpLimitChange] AS TABLE (
    [High]             VARCHAR (25)  NULL,
    [Low]              VARCHAR (25)  NULL,
    [ExtremeHigh]      VARCHAR (25)  NULL,
    [ExtremeLow]       VARCHAR (25)  NULL,
    [Desat]            VARCHAR (25)  NULL,
    [AcquiredDateTime] DATETIME2 (7) NOT NULL,
    [TopicSessionID]   INT           NOT NULL,
    [FeedTypeID]       INT           NOT NULL,
    [EnumGroupID]      INT           NOT NULL,
    [IDEnumValue]      INT           NOT NULL);

