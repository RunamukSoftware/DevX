
CREATE VIEW [dbo].[v_StatusData]
WITH
     SCHEMABINDING
AS
SELECT
    [StatusData].[Id],
    [StatusData].[SetId],
    [StatusData].[Name],
    [StatusData].[Value] AS [ResultValue],
    [TopicSessions].[TopicTypeId],
    [TopicSessions].[Id] AS [TopicSessionId],
    [StatusDataSets].[TimestampUTC] AS [DateTimeStampUTC],
    --[dbo].[fnUtcDateTimeToLocalTime]([StatusDataSets].[TimestampUTC]) AS [DateTimeStamp],
    [DateTimeStamp].[LocalDateTime] AS [DateTimeStamp],
    [v_PatientTopicSessions].[PatientId] AS [PatientId],
    --[dbo].[fnDateTimeToFileTime]([StatusDataSets].[TimestampUTC]) AS [FileDateTimeStamp],
    [FileDateTimeStamp].[FileTime] AS [FileDateTimeStamp],
    [GdsCode] = CASE [StatusData].[Name]
                  WHEN 'lead1Index' THEN '2.1.2.0'
                  WHEN 'lead2Index' THEN '2.2.2.0'
                  ELSE [StatusData].[Name]
                END,
    [StatusDataSets].[FeedTypeId] AS [FeedTypeId]
FROM
    [dbo].[StatusData]
    INNER JOIN [dbo].[StatusDataSets] ON [StatusData].[SetId] = [StatusDataSets].[Id]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [StatusDataSets].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([StatusDataSets].[TimestampUTC]) AS [DateTimeStamp]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([StatusDataSets].[TimestampUTC]) AS [FileDateTimeStamp]

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_StatusData';

