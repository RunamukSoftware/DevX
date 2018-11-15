CREATE TABLE [old].[PrintJob] (
    [PrintJobID]      INT           IDENTITY (1, 1) NOT NULL,
    [TopicSessionID]  INT           NOT NULL,
    [FeedTypeID]      INT           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_PrintJob_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintJob_PrintJobID] PRIMARY KEY CLUSTERED ([PrintJobID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintJob_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_PrintJob_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores print job information.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PrintJob';

