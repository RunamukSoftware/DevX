CREATE VIEW [dbo].[v_LegacyWaveform]
WITH
     SCHEMABINDING
AS
SELECT
    [WaveformData].[Id],
    [WaveformData].[SampleCount],
    [v_WaveformSampleRate].[TypeName],
    [WaveformData].[TypeId],
    [WaveformData].[Samples] AS [WaveformData],
    [TopicSessions].[TopicTypeId],
    [WaveformData].[TopicSessionId],
    [TopicSessions].[DeviceSessionId],
    [TopicSessions].[BeginTimeUTC] AS [SessionBeginUTC],
    [WaveformData].[StartTimeUTC] AS [TimeStampBeginUTC],
    [WaveformData].[EndTimeUTC] AS [TimeStampEndUTC],
    --[dbo].[fnDateTimeToFileTime]([WaveformData].[StartTimeUTC]) AS [FileTimeStampBeginUTC],
    --[dbo].[fnDateTimeToFileTime]([WaveformData].[EndTimeUTC]) AS [FileTimeStampEndUTC],
    [FileTimeStampBeginUTC].[FileTime] AS [FileTimeStampBeginUTC],
    [FileTimeStampEndUTC].[FileTime] AS [FileTimeStampEndUTC],
    [v_WaveformSampleRate].[SampleRate],
    [v_PatientTopicSessions].[PatientId],
    [TopicSessions].[TopicInstanceId],
    CASE WHEN [WaveformData].[Compressed] = 0 THEN NULL
         ELSE 'WCTZLIB'
    END AS [CompressMethod]
FROM
    [dbo].[WaveformData]
    INNER JOIN [dbo].[v_WaveformSampleRate] ON [v_WaveformSampleRate].[FeedTypeId] = [WaveformData].[TypeId]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [WaveformData].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([WaveformData].[StartTimeUTC]) AS [FileTimeStampBeginUTC]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([WaveformData].[EndTimeUTC]) AS [FileTimeStampEndUTC]
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyWaveform';
