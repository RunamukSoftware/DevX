CREATE VIEW [dbo].[v_ActivePatientChannels]
WITH
     SCHEMABINDING
AS
SELECT
    [NonWaveformChannelTypes].[TypeId],
    [TopicTypeId],
    [PatientId],
    [Active] = CASE WHEN [EndTimeUTC] IS NULL THEN 1
                    ELSE NULL
               END
FROM
    (SELECT DISTINCT
        [TopicTypeId],
        [v_PatientTopicSessions].[PatientId],
        NULL AS [TypeId],
        [EndTimeUTC]
     FROM
        [dbo].[TopicSessions]
        INNER JOIN [dbo].[v_PatientTopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
     WHERE
        [TopicTypeId] IN (SELECT
                            [TopicTypeId]
                          FROM
                            [dbo].[v_LegacyChannelTypes]
                          WHERE
                            [TypeId] IS NULL)
    ) AS [NonWaveformChannelTypes]
UNION ALL
(SELECT
    [TypeId],
    [TopicTypeId],
    [v_PatientTopicSessions].[PatientId],
    [Active] = CASE WHEN [TopicSessions].[EndTimeUTC] IS NULL THEN 1
                    ELSE NULL
               END
 FROM
    [dbo].[WaveformLiveData] AS [WAVEFRM]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [WAVEFRM].[TopicInstanceId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
 GROUP BY
    [TypeId],
    [TopicTypeId],
    [PatientId],
    [TopicSessions].[EndTimeUTC]
 UNION
 SELECT  
DISTINCT
    [TopicSessions].[TopicTypeId] AS [TypeId],
    [TopicSessions].[TopicTypeId],
    [v_PatientTopicSessions].[PatientId],
    [Active] = CASE WHEN [EndTimeUTC] IS NULL THEN 1
                    ELSE NULL
               END
 FROM
    [dbo].[VitalsData]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [VitalsData].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
 WHERE
    [TopicSessions].[TopicTypeId] NOT IN (SELECT DISTINCT
                                            [TopicTypeId]
                                          FROM
                                            [dbo].[WaveformData]
                                            INNER JOIN [dbo].[TopicSessions] AS [ts] ON [ts].[Id] = [WaveformData].[TopicSessionId])
    AND [TopicTypeId] IN (SELECT
                            [TopicTypeId]
                          FROM
                            [dbo].[v_LegacyChannelTypes]
                          WHERE
                            [TypeId] IS NOT NULL)
);

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the latest channel types from waveforms and topics from non-waveform.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_ActivePatientChannels';

