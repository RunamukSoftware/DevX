CREATE PROCEDURE [old].[uspGetPatientVitalSignByChannels]
    (
        @PatientID    INT,
        @ChannelTypes [old].[utpStringList] READONLY
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @VitalValue [old].[utpVitalValue];

        INSERT INTO @VitalValue
            (
                [VitalValue]
            )
                    SELECT
                        [ivl].[VitalValue]
                    FROM
                        [Intesys].[VitalLive] AS [ivl]
                    WHERE
                        [ivl].[PatientID] = @PatientID;

        ((SELECT
                  [tft].[FeedTypeID]  AS [PatientChannelID],
                  [VitalsAll].[GlobalDataSystemCode],
                  [VitalsAll].[Value] AS [VitalValue],
                  [icv].[FormatString]
          FROM
                  @ChannelTypes            AS [CHT]
              INNER JOIN
                  [old].[FeedType]         AS [tft]
                      ON [tft].[FeedTypeID] = [CHT].[Item]
              INNER JOIN
                  [Intesys].[ChannelVital] AS [icv]
                      ON [icv].[ChannelTypeID] = [tft].[ChannelTypeID]
              INNER JOIN
                  (
                      SELECT
                              ROW_NUMBER() OVER (PARTITION BY
                                                     [ld].[TopicInstanceID],
                                                     [gcm].[GlobalDataSystemCode]
                                                 ORDER BY
                                                     [ld].[Timestamp] DESC
                                                ) AS [RowNumber],
                              [ld].[FeedTypeID],
                              [ld].[TopicInstanceID],
                              [ld].[Name],
                              [ld].[Value],
                              [gcm].[GlobalDataSystemCode],
                              [gcm].[CodeID]
                      FROM
                              [old].[LiveData]                AS [ld]
                          INNER JOIN
                              [old].[TopicSession]            AS [ts]
                                  ON [ts].[TopicInstanceID] = [ld].[TopicInstanceID]
                                     AND [ts].[EndDateTime] IS NULL
                          INNER JOIN
                              [old].[GlobalDataSystemCodeMap] AS [gcm]
                                  ON [gcm].[FeedTypeID] = [ld].[FeedTypeID]
                                     AND [gcm].[Name] = [ld].[Name]
                      WHERE
                              [ts].[TopicSessionID] IN (
                                                           SELECT
                                                               [vpts].[TopicSessionID]
                                                           FROM
                                                               [old].[vwPatientTopicSessions] AS [vpts]
                                                           WHERE
                                                               [vpts].[PatientID] = @PatientID
                                                       )
                  )                        AS [VitalsAll]
                      ON [VitalsAll].[CodeID] = [icv].[GlobalDataSystemCodeID]
          WHERE
                  [VitalsAll].[RowNumber] = 1)
         UNION ALL
         (SELECT
                  [ipc].[ChannelTypeID]     AS [PatientChannelID],
                  [MSCODE].[Code]           AS [GlobalDataSystemCode],
                  [LiveValue].[ResultValue] AS [VitalValue],
                  --TODATETIMEOFFSET (CONVERT(DATETIME,STUFF(STUFF(STUFF(LiveTime.ResultTime, 9, 0, ' '), 12, 0, ':'), 15, 0, ':')) ,DATENAME(tz, SYSDATETIMEOFFSET())) AS CollectionDateTime,
                  [icv].[FormatString]      AS [FORMAT_STRING]
          FROM
                  [Intesys].[PatientChannel]    AS [ipc]
              INNER JOIN
                  [Intesys].[ChannelVital]      AS [icv]
                      ON [ipc].[ChannelTypeID] = [icv].[ChannelTypeID]
                         AND [ipc].[ActiveSwitch] = 1
              INNER JOIN
                  [Intesys].[VitalLive]         AS [ivl]
                      ON [ipc].[PatientID] = [ivl].[PatientID]
              LEFT OUTER JOIN
                  (
                      SELECT
                          [idx],
                          [value],
                          SUBSTRING([value], CHARINDEX('=', [value]) + 1, LEN([value])) AS [ResultValue],
                          CONVERT(INT, SUBSTRING([value], 0, CHARINDEX('=', [value])))  AS [GlobalDataSystemCodeID]
                      FROM
                          [old].[ufnVitalMerge]((@VitalValue), '|')
                  )                             AS [LiveValue]
                      ON [LiveValue].[GlobalDataSystemCodeID] = [icv].[GlobalDataSystemCodeID]
              LEFT OUTER JOIN
                  [Intesys].[MiscellaneousCode] AS [MSCODE]
                      ON [MSCODE].[CodeID] = [icv].[GlobalDataSystemCodeID]
                         AND [MSCODE].[Code] IS NOT NULL
          WHERE
                  [ipc].[PatientID] = @PatientID
                  AND [ipc].[ChannelTypeID] IN (
                                                   SELECT
                                                       [Item]
                                                   FROM
                                                       @ChannelTypes
                                               )
                  AND [ipc].[ActiveSwitch] = 1
                  AND [LiveValue].[idx] IS NOT NULL))
        ORDER BY
            VitalValue;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalSignByChannels';

