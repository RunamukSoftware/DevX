CREATE TYPE [old].[utpLimitAlarm] AS TABLE (
    [AlarmID]             INT           NOT NULL,
    [SettingViolated]     VARCHAR (25)  NOT NULL,
    [ViolatingValue]      VARCHAR (25)  NOT NULL,
    [StartDateTime]       DATETIME2 (7) NULL,
    [EndDateTime]         DATETIME2 (7) NULL,
    [StatusValue]         INT           NOT NULL,
    [DetectionTimestamp]  DATETIME2 (7) NULL,
    [Acknowledged]        BIT           NOT NULL,
    [PriorityWeightValue] INT           NOT NULL,
    [AcquiredDateTime]    DATETIME2 (7) NOT NULL,
    [Leads]               INT           NOT NULL,
    [WaveformFeedTypeID]  INT           NOT NULL,
    [TopicSessionID]      INT           NOT NULL,
    [FeedTypeID]          INT           NOT NULL,
    [IDEnumValue]         INT           NULL,
    [EnumGroupID]         INT           NOT NULL);

