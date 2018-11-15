CREATE VIEW [dbo].[v_AvailableDataTypes]
WITH
     SCHEMABINDING
AS
SELECT
    [NonWaveformChannelTypes].[TypeId],
    [TopicTypeId],
    [DeviceSessionId],
    [PatientId],
    [Active] = CASE WHEN [EndTimeUTC] IS NULL THEN 1
                    ELSE NULL
               END
FROM
    (SELECT DISTINCT
        [TopicTypeId],
        [DeviceSessionId],
        [PatientId],
        NULL AS [TypeId],
        [EndTimeUTC]
     FROM
        [dbo].[TopicSessions]
        INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
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
DISTINCT
    [TypeId],
    [TopicTypeId],
    [DeviceSessionId],
    [PatientId],
    CASE WHEN [TopicSessions].[EndTimeUTC] IS NULL THEN 1
         ELSE NULL
    END AS [Active]
 FROM
    [dbo].[WaveformData]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [WaveformData].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
 UNION ALL
 SELECT DISTINCT
    [TopicSessions].[TopicTypeId] AS [TypeId],
    [TopicSessions].[TopicTypeId],
    [DeviceSessionId],
    [PatientId],
    CASE WHEN [EndTimeUTC] IS NULL THEN 1
         ELSE NULL
    END AS [Active]
 FROM
    [dbo].[VitalsData]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [VitalsData].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
 WHERE
    [TopicSessions].[TopicTypeId] NOT IN (SELECT DISTINCT
                                            [TopicTypeId]
                                          FROM
                                            [dbo].[WaveformData]
                                            INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [WaveformData].[TopicSessionId])
    AND [TopicTypeId] IN (SELECT
                            [TopicTypeId]
                          FROM
                            [dbo].[v_LegacyChannelTypes]
                          WHERE
                            [TypeId] IS NOT NULL)
);

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_AvailableDataTypes';

