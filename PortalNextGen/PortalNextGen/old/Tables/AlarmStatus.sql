CREATE TABLE [old].[AlarmStatus] (
    [AlarmStatusID]      INT           IDENTITY (1, 1) NOT NULL,
    [AlarmID]            INT           NOT NULL,
    [StatusTimeout]      TINYINT       NULL,
    [StatusValue]        INT           NOT NULL,
    [AcquiredDateTime]   DATETIME2 (7) NOT NULL,
    [Leads]              INT           NOT NULL,
    [WaveformFeedTypeID] INT           NOT NULL,
    [TopicSessionID]     INT           NOT NULL,
    [FeedTypeID]         INT           NOT NULL,
    [IDEnumValue]        INT           NOT NULL,
    [EnumGroupID]        INT           NOT NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_AlarmStatus_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AlarmStatus_AlarmStatusID] PRIMARY KEY CLUSTERED ([AlarmStatusID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AlarmStatus_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_AlarmStatus_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'AlarmStatus';

