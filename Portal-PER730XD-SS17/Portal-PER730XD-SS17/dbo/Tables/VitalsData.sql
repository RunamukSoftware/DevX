CREATE TABLE [dbo].[VitalsData] (
    [ID]              BIGINT           IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [SetId]           UNIQUEIDENTIFIER NOT NULL,
    [Name]            VARCHAR (25)     NOT NULL,
    [Value]           VARCHAR (25)     NULL,
    [TopicSessionId]  UNIQUEIDENTIFIER NOT NULL,
    [FeedTypeId]      UNIQUEIDENTIFIER NOT NULL,
    [TimestampUTC]    DATETIME         NOT NULL,
    [CreatedDateTime] DATETIME2 (7)    CONSTRAINT [DF_VitalsData_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_VitalsData_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_TimestampUTC_ID]
    ON [dbo].[VitalsData]([TimestampUTC] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_TopicSessionId_TimestampUTC_Name_FeedTypeId_ID_Value]
    ON [dbo].[VitalsData]([TopicSessionId] ASC, [TimestampUTC] ASC, [Name] ASC, [FeedTypeId] ASC)
    INCLUDE([ID], [Value]) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_TopicSessionId_FeedTypeId_Name_Value_TimestampUTC]
    ON [dbo].[VitalsData]([TopicSessionId] ASC, [FeedTypeId] ASC, [Name] ASC)
    INCLUDE([Value], [TimestampUTC]) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_TopicSessionId_Name_FeedTypeId_includes]
    ON [dbo].[VitalsData]([TopicSessionId] ASC, [Name] ASC, [FeedTypeId] ASC)
    INCLUDE([ID], [Value], [TimestampUTC]) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patient vital sign data', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VitalsData';

GO
CREATE NONCLUSTERED INDEX [IX_VitalsData_Name_FeedTypeId_includes]
    ON [dbo].[VitalsData]([Name] ASC, [FeedTypeId] ASC)
    INCLUDE([Value], [TopicSessionId], [TimestampUTC]) WITH (FILLFACTOR = 100);

