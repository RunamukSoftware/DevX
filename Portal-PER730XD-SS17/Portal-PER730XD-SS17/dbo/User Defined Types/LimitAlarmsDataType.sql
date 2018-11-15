CREATE TYPE [dbo].[LimitAlarmsDataType] AS TABLE (
    [AlarmId]             UNIQUEIDENTIFIER NOT NULL,
    [SettingViolated]     VARCHAR (25)     NOT NULL,
    [ViolatingValue]      VARCHAR (25)     NOT NULL,
    [StartDateTime]       DATETIME         NULL,
    [EndDateTime]         DATETIME         NULL,
    [StatusValue]         INT              NOT NULL,
    [DetectionTimestamp]  DATETIME         NULL,
    [Acknowledged]        BIT              NOT NULL,
    [PriorityWeightValue] INT              NOT NULL,
    [AcquiredDateTimeUTC] DATETIME         NOT NULL,
    [Leads]               INT              NOT NULL,
    [WaveformFeedTypeId]  UNIQUEIDENTIFIER NOT NULL,
    [TopicSessionId]      UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]          UNIQUEIDENTIFIER NOT NULL,
    [IDEnumValue]         INT              NULL,
    [EnumGroupId]         UNIQUEIDENTIFIER NOT NULL);

