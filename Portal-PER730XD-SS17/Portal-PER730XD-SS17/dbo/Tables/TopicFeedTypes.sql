CREATE TABLE [dbo].[TopicFeedTypes] (
    [FeedTypeId]    UNIQUEIDENTIFIER NOT NULL,
    [TopicTypeId]   UNIQUEIDENTIFIER NOT NULL,
    [ChannelCode]   INT              NOT NULL,
    [ChannelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [SampleRate]    SMALLINT         NULL,
    [Label]         NVARCHAR (250)   NOT NULL,
    CONSTRAINT [PK_TopicFeedTypes_FeedTypeId] PRIMARY KEY CLUSTERED ([FeedTypeId] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TopicFeedTypes';

