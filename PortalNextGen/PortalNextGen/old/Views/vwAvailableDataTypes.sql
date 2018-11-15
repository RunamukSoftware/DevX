CREATE VIEW [old].[vwAvailableDataTypes]
WITH SCHEMABINDING
AS
    SELECT
        [NonWaveformChannelTypes].[TypeID],
        [NonWaveformChannelTypes].[TopicTypeID],
        [NonWaveformChannelTypes].[DeviceSessionID],
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
                [ts].[DeviceSessionID],
                [vpts].[PatientID],
                NULL  AS [TypeID],
                [ts].[EndDateTime]
            FROM
                [old].[TopicSession]               AS [ts]
                INNER JOIN
                    [old].[vwPatientTopicSessions] AS [vpts]
                        ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
            WHERE
                [ts].[TopicTypeID] IN (
                                          SELECT
                                              [vlct].[TopicTypeID]
                                          FROM
                                              [old].[vwLegacyChannelTypes] AS [vlct]
                                          WHERE
                                              [vlct].[TypeID] IS NULL
                                      )
        ) AS [NonWaveformChannelTypes]
    UNION ALL
    (SELECT DISTINCT
         [w].[TypeID],
         [ts].[TopicTypeID],
         [ts].[DeviceSessionID],
         [vpts].[PatientID],
         CASE
             WHEN [ts].[EndDateTime] IS NULL
                 THEN 1
             ELSE
                 NULL
         END AS [Active]
     FROM
         [old].[Waveform]                   AS [w]
         INNER JOIN
             [old].[TopicSession]           AS [ts]
                 ON [ts].[TopicSessionID] = [w].[TopicSessionID]
         INNER JOIN
             [old].[vwPatientTopicSessions] AS [vpts]
                 ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
     UNION ALL
     SELECT DISTINCT
         [ts].[TopicTypeID] AS [TypeID],
         [ts].[TopicTypeID],
         [ts].[DeviceSessionID],
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
                 ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
     WHERE
         [ts].[TopicTypeID] NOT IN (
                                       SELECT DISTINCT
                                           [ts2].[TopicTypeID]
                                       FROM
                                           [old].[Waveform]         AS [w]
                                           INNER JOIN
                                               [old].[TopicSession] AS [ts2]
                                                   ON [ts2].[TopicSessionID] = [w].[TopicSessionID]
                                   )
         AND [ts].[TopicTypeID] IN (
                                       SELECT
                                           [vlct].[TopicTypeID]
                                       FROM
                                           [old].[vwLegacyChannelTypes] AS [vlct]
                                       WHERE
                                           [vlct].[TypeID] IS NOT NULL
                                   ));
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwAvailableDataTypes';

