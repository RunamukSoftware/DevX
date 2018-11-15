CREATE TABLE [old].[LiveData] (
    [LiveDataID]      BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [TopicInstanceID] INT           NOT NULL,
    [FeedTypeID]      INT           NOT NULL,
    [Name]            VARCHAR (25)  NOT NULL,
    [Value]           VARCHAR (25)  NULL,
    [Timestamp]       DATETIME2 (7) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_LiveData_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LiveData_TimestampUTC_LiveDataID] PRIMARY KEY CLUSTERED ([Timestamp] ASC, [LiveDataID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_LiveData_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID])
);


GO
CREATE NONCLUSTERED INDEX [IX_LiveData_TopicInstanceId_FeedTypeID_Timestamp]
    ON [old].[LiveData]([TopicInstanceID] ASC, [FeedTypeID] ASC, [Timestamp] DESC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the live feed data for a patient topic session.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'LiveData';

