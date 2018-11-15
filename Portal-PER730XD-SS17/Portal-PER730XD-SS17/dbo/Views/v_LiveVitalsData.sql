
CREATE VIEW [dbo].[v_LiveVitalsData]
WITH
     SCHEMABINDING
AS
SELECT
    [LiveData].[Name],
    [LiveData].[Value] AS [ResultValue],
    [TopicSessions].[TopicTypeId],
    [TopicSessions].[Id] AS [TopicSessionId],
    [v_PatientTopicSessions].[PatientId] AS [PatientId],
    [TopicSessions].[TopicInstanceId],
    CASE [LiveData].[Name]
      WHEN 'T1Value' THEN '4.6.' + CAST((1 + CAST([dbo].[fnZeroIfBigger]([vdt1].[Value], 32767) AS INT)) AS NVARCHAR(15)) + '.0'
      WHEN 'T2Value' THEN '4.7.' + CAST((1 + CAST([dbo].[fnZeroIfBigger]([vdt2].[Value], 32767) AS INT)) AS NVARCHAR(15)) + '.0'
      WHEN 'lead1Index' THEN '2.1.2.0'
      WHEN 'lead2Index' THEN '2.2.2.0'
      ELSE [GdsMetaData].[Value]
    END AS [GdsCode],
    [LiveData].[TimestampUTC] AS [DateTimeStampUTC],
    --[dbo].[fnUtcDateTimeToLocalTime]([LiveData].[TimestampUTC]) AS [DateTimeStamp],
    --[dbo].[fnDateTimeToFileTime]([LiveData].[TimestampUTC]) AS [FileDateTimeStamp],
    [DateTimeStamp].[LocalDateTime] AS [DateTimeStamp],
    [FileDateTimeStamp].[FileTime] AS [FileDateTimeStamp],
    [LiveData].[FeedTypeId]
FROM
    [dbo].[LiveData]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [LiveData].[TopicInstanceId]
                                        AND [TopicSessions].[EndTimeUTC] IS NULL
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
    LEFT OUTER JOIN [dbo].[v_MetaData] AS [GdsMetaData] ON [GdsMetaData].[TypeId] = [LiveData].[FeedTypeId]
                                                           AND [GdsMetaData].[EntityMemberName] = [LiveData].[Name]
                                                           AND [GdsMetaData].[Name] = 'GdsCode'
    LEFT OUTER JOIN [dbo].[LiveData] AS [vdt1] ON [LiveData].[Id] = [vdt1].[Id]
                                                  AND [vdt1].[Name] = 'T1Location'
    LEFT OUTER JOIN [dbo].[LiveData] AS [vdt2] ON [LiveData].[Id] = [vdt2].[Id]
                                                  AND [vdt2].[Name] = 'T2Location'
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([LiveData].[TimestampUTC]) AS [DateTimeStamp]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([LiveData].[TimestampUTC]) AS [FileDateTimeStamp]

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LiveVitalsData';

