CREATE TABLE [old].[FeedType] (
    [FeedTypeID]      INT            IDENTITY (1, 1) NOT NULL,
    [TopicTypeID]     INT            NOT NULL,
    [ChannelCode]     INT            NOT NULL,
    [ChannelTypeID]   INT            NOT NULL,
    [SampleRate]      SMALLINT       NULL,
    [Label]           NVARCHAR (250) NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_FeedType_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_FeedType_FeedTypeID] PRIMARY KEY CLUSTERED ([FeedTypeID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_FeedType_TopicType_TopicTypeID] FOREIGN KEY ([TopicTypeID]) REFERENCES [old].[TopicType] ([TopicTypeID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'FeedType';

