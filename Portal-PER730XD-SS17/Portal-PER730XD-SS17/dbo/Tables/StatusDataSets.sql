CREATE TABLE [dbo].[StatusDataSets] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [TopicSessionId] UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]     UNIQUEIDENTIFIER NOT NULL,
    [TimestampUTC]   DATETIME         NOT NULL,
    [Sequence]       BIGINT           IDENTITY (-9223372036854775808, 1) NOT NULL,
    CONSTRAINT [PK_StatusDataSets_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_StatusDataSets_Id] 
ON [dbo].[StatusDataSets] ([Id] ASC)
WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'StatusDataSets';

GO
CREATE NONCLUSTERED INDEX [IX_StatusDataSets_TimestampUTC_Id]
    ON [dbo].[StatusDataSets]([TimestampUTC] ASC)
    INCLUDE([Id]) WITH (FILLFACTOR = 100);

