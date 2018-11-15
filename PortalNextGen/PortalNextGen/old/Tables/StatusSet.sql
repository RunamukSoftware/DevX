CREATE TABLE [old].[StatusSet] (
    [StatusSetID]     INT           IDENTITY (1, 1) NOT NULL,
    [TopicSessionID]  INT           NOT NULL,
    [FeedTypeID]      INT           NOT NULL,
    [Timestamp]       DATETIME2 (7) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_StatusSet_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_StatusSet_StatusSetID] PRIMARY KEY CLUSTERED ([StatusSetID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_StatusSet_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_StatusSet_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_StatusSet_TimestampUTC_StatusSetID]
    ON [old].[StatusSet]([Timestamp] ASC)
    INCLUDE([StatusSetID]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'StatusSet';

