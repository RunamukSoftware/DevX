CREATE TYPE [dbo].[NameValueDataSetType] AS TABLE (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [SetId]          UNIQUEIDENTIFIER NOT NULL,
    [Name]           VARCHAR (25)     NOT NULL,
    [Value]          VARCHAR (25)     NULL,
    [FeedTypeId]     UNIQUEIDENTIFIER NOT NULL,
    [TopicSessionId] UNIQUEIDENTIFIER NOT NULL,
    [TimestampUTC]   DATETIME         NOT NULL);

