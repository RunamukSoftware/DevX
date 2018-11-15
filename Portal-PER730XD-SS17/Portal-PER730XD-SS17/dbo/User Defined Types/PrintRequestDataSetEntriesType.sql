CREATE TYPE [dbo].[PrintRequestDataSetEntriesType] AS TABLE (
    [PrintRequestId]       UNIQUEIDENTIFIER NOT NULL,
    [PrintJobId]           UNIQUEIDENTIFIER NOT NULL,
    [TopicSessionId]       UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]           UNIQUEIDENTIFIER NOT NULL,
    [RequestTypeEnumId]    UNIQUEIDENTIFIER NOT NULL,
    [RequestTypeEnumValue] INT              NOT NULL,
    [TimestampUTC]         DATETIME         NOT NULL);

