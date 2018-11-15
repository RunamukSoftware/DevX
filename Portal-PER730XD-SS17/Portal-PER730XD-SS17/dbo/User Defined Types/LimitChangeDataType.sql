CREATE TYPE [dbo].[LimitChangeDataType] AS TABLE (
    [Id]                  UNIQUEIDENTIFIER NOT NULL,
    [High]                VARCHAR (25)     NULL,
    [Low]                 VARCHAR (25)     NULL,
    [ExtremeHigh]         VARCHAR (25)     NULL,
    [ExtremeLow]          VARCHAR (25)     NULL,
    [Desat]               VARCHAR (25)     NULL,
    [AcquiredDateTimeUTC] DATETIME         NOT NULL,
    [TopicSessionId]      UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]          UNIQUEIDENTIFIER NOT NULL,
    [EnumGroupId]         UNIQUEIDENTIFIER NOT NULL,
    [IDEnumValue]         INT              NOT NULL);

