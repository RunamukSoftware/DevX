CREATE TABLE [dbo].[LiveData] (
    [Sequence]        BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [TopicInstanceId] UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]      UNIQUEIDENTIFIER NOT NULL,
    [Name]            VARCHAR (25)     NOT NULL,
    [Value]           VARCHAR (25)     NULL,
    [TimestampUTC]    DATETIME         NOT NULL,
    [CreatedUTC]      DATETIME2 (7)    CONSTRAINT [DF_LiveData_CreatedUTC] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LiveData_TopicInstanceId_FeedTypeId_TimestampUTC_Sequence] PRIMARY KEY NONCLUSTERED ([TopicInstanceId] ASC, [FeedTypeId] ASC, [TimestampUTC] ASC, [Sequence] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

