CREATE VIEW [dbo].[v_VitalsData]
WITH
     SCHEMABINDING
AS
SELECT
    [vd].[ID],
    [vd].[SetId],
    [vd].[Name],
    [vd].[Value] AS [ResultValue],
    [ts].[TopicTypeId],
    [ts].[Id] AS [TopicSessionId],
    [vd].[TimestampUTC] AS [DateTimeStampUTC],
    [vpts].[PatientId] AS [PatientId],
    [gcm].[GdsCode] AS [GdsCode],
    [vd].[FeedTypeId] AS [TypeId]
FROM
    [dbo].[VitalsData] AS [vd]
    INNER JOIN [dbo].[GdsCodeMap] AS [gcm] ON [gcm].[FeedTypeId] = [vd].[FeedTypeId]
                                              AND [gcm].[Name] = [vd].[Name]
    INNER JOIN [dbo].[TopicSessions] AS [ts] ON [ts].[Id] = [vd].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] AS [vpts] ON [vpts].[TopicSessionId] = [ts].[Id];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the vitals data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_VitalsData';

