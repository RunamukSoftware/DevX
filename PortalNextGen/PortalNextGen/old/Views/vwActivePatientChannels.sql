CREATE VIEW [old].[vwActivePatientChannels]
WITH SCHEMABINDING
AS
    SELECT
        [NonWaveformChannelTypes].[TypeID],
        [NonWaveformChannelTypes].[TopicTypeID],
        [NonWaveformChannelTypes].[PatientID],
        CASE
            WHEN [NonWaveformChannelTypes].[EndDateTime] IS NULL
                THEN 1
            ELSE
                NULL
        END AS [Active]
    FROM
        (
            SELECT DISTINCT
                [ts].[TopicTypeID],
                [vpts].[PatientID],
                NULL  AS [TypeID],
                [ts].[EndDateTime]
            FROM
                [old].[TopicSession]               AS [ts]
                INNER JOIN
                    [old].[vwPatientTopicSessions] AS [vpts]
                        ON [ts].[TopicSessionID] = [vpts].[TopicSessionID]
            WHERE
                [ts].[TopicTypeID] IN (
                                          SELECT
                                              [TopicTypeID]
                                          FROM
                                              [old].[vwLegacyChannelTypes]
                                          WHERE
                                              [TypeID] IS NULL
                                      )
        ) AS [NonWaveformChannelTypes]
    UNION ALL
    (SELECT
         [WAVEFRM].[TypeID],
         [ts].[TopicTypeID],
         [vpts].[PatientID],
         CASE
             WHEN [ts].[EndDateTime] IS NULL
                 THEN 1
             ELSE
                 NULL
         END AS [Active]
     FROM
         [old].[WaveformLive]               AS [WAVEFRM]
         INNER JOIN
             [old].[TopicSession]           AS [ts]
                 ON [ts].[TopicInstanceID] = [WAVEFRM].[TopicInstanceID]
         INNER JOIN
             [old].[vwPatientTopicSessions] AS [vpts]
                 ON [ts].[TopicSessionID] = [vpts].[TopicSessionID]
     GROUP BY
         [WAVEFRM].[TypeID],
         [ts].[TopicTypeID],
         [vpts].[PatientID],
         [ts].[EndDateTime]
     UNION
     SELECT DISTINCT
         [ts].[TopicTypeID] AS [TypeID],
         [ts].[TopicTypeID],
         [vpts].[PatientID],
         CASE
             WHEN [ts].[EndDateTime] IS NULL
                 THEN 1
             ELSE
                 NULL
         END                AS [Active]
     FROM
         [old].[Vital]                 AS [vd]
         INNER JOIN
             [old].[TopicSession]           AS [ts]
                 ON [ts].[TopicSessionID] = [vd].[TopicSessionID]
         INNER JOIN
             [old].[vwPatientTopicSessions] AS [vpts]
                 ON [ts].[TopicSessionID] = [vpts].[TopicSessionID]
     WHERE
         [ts].[TopicTypeID] NOT IN (
                                       SELECT DISTINCT
                                           [ts1].[TopicTypeID]
                                       FROM
                                           [old].[Waveform]         AS [w]
                                           INNER JOIN
                                               [old].[TopicSession] AS [ts1]
                                                   ON [ts1].[TopicSessionID] = [w].[TopicSessionID]
                                   )
         AND [ts].[TopicTypeID] IN (
                                       SELECT
                                           [TopicTypeID]
                                       FROM
                                           [old].[vwLegacyChannelTypes]
                                       WHERE
                                           [TypeID] IS NOT NULL
                                   ));
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the latest channel types from waveforms and topics from non-waveform.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwActivePatientChannels';

