CREATE PROCEDURE [old].[uspGetPatientAlarms]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7),
        @Locale        VARCHAR(7) = 'en'
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ia].[AlarmID],
            [ict].[ChannelCode]           AS [Type],
            ISNULL([ia].[AlarmCode], N'') AS [TypeString],
            ISNULL([ia].[AlarmCode], N'') AS [TITLE],
            [ia].[StartDateTime],
            [ia].[EndDateTime],
            [ia].[Removed]                AS [Removed],
            [ia].[AlarmLevel]             AS [priority],
            CAST('' AS NVARCHAR(250))     AS [Label]
        FROM
            [Intesys].[Alarm]              AS [ia]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [ia].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ia].[PatientID] = @PatientID
            AND [ia].[AlarmLevel] > 0
            AND (
                    @StartDateTime < [ia].[EndDateTime]
                    OR [ia].[EndDateTime] IS NULL
                )
        UNION ALL
        SELECT
            [la].[LimitAlarmID],
            [tft].[ChannelCode]                                                              AS [Type],
            ISNULL([ar].[Message], [ar].[AlarmTypeName])                                     AS [TypeString],
            ISNULL([ar].[Message], N'') + '  ' + REPLACE(ISNULL([ar].[ValueFormat], ''), '{0}', [la].[ViolatingValue])
            + '  ' + REPLACE(ISNULL([ar].[LimitFormat], N''), '{0}', [la].[SettingViolated]) AS [Title],
            [la].[StartDateTime]                                                             AS [StartDateTime],
            ISNULL([la].[EndDateTime], [ts].[EndDateTime])                                   AS [EndDateTime],
            [ra].[RemovedFlag],
            CASE
                WHEN [la].[PriorityWeightValue] = 0
                    THEN 0 -- none/message
                WHEN [la].[PriorityWeightValue] = 1
                    THEN 3 -- low
                WHEN [la].[PriorityWeightValue] = 2
                    THEN 2 -- medium
                ELSE
                    1      -- high
            END                                                                              AS [Priority],
            CAST(N'' AS NVARCHAR(250))                                                       AS [Label]
        FROM
            [old].[LimitAlarm]                 AS [la]
            INNER JOIN
                [old].[AlarmResource]          AS [ar]
                    ON [ar].[EnumGroupID] = [la].[EnumGroupID]
                       AND [ar].[IDEnumValue] = [la].[IDEnumValue]
                       AND [ar].[Locale] = @Locale
            INNER JOIN
                [old].[FeedType]               AS [tft]
                    ON [tft].[FeedTypeID] = [la].[WaveformFeedTypeID]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [la].[TopicSessionID]
            INNER JOIN
                [old].[TopicSession]           AS [ts]
                    ON [ts].[TopicSessionID] = [la].[TopicSessionID]
            LEFT OUTER JOIN
                [old].[RemovedAlarm]           AS [ra]
                    ON [ra].[AlarmID] = [la].[LimitAlarmID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [StartDateTime] <= @EndDateTime
            AND (
                    (
                        [la].[EndDateTime] IS NULL
                        AND [ts].[EndDateTime] IS NULL
                    )
                    OR @StartDateTime <= ISNULL([la].[EndDateTime], [ts].[EndDateTime])
                )
        UNION ALL
        SELECT
            [gad].[GeneralAlarmID],
            [tft].[ChannelCode]                             AS [Type],
            ISNULL([ar].[Message], [ar].[AlarmTypeName])    AS [TypeString],
            ISNULL([ar].[Message], N'')                     AS [Title],
            [gad].[StartDateTime]                           AS [StartDateTime],
            ISNULL([gad].[EndDateTime], [ts].[EndDateTime]) AS [EndDateTime],
            [ra].[RemovedFlag],
            CASE
                WHEN [gad].[PriorityWeightValue] = 0
                    THEN 0 -- none/message
                WHEN [gad].[PriorityWeightValue] = 1
                    THEN 3 -- low
                WHEN [gad].[PriorityWeightValue] = 2
                    THEN 2 -- medium
                ELSE
                    1      -- high
            END                                             AS [Priority],
            CAST(N'' AS NVARCHAR(250))                      AS [Label]
        FROM
            [old].[GeneralAlarm]               AS [gad]
            INNER JOIN
                [old].[AlarmResource]          AS [ar]
                    ON [ar].[EnumGroupID] = [gad].[EnumGroupID]
                       AND [ar].[IDEnumValue] = [gad].[IDEnumValue]
                       AND [ar].[Locale] = @Locale
            INNER JOIN
                [old].[FeedType]               AS [tft]
                    ON [tft].[FeedTypeID] = [gad].[WaveformFeedTypeID]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [gad].[TopicSessionID]
            INNER JOIN
                [old].[TopicSession]           AS [ts]
                    ON [ts].[TopicSessionID] = [gad].[TopicSessionID]
            LEFT OUTER JOIN
                [old].[RemovedAlarm]           AS [ra]
                    ON [ra].[AlarmID] = [gad].[GeneralAlarmID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [StartDateTime] <= @EndDateTime
            AND (
                    (
                        [gad].[EndDateTime] IS NULL
                        AND [ts].[EndDateTime] IS NULL
                    )
                    OR @StartDateTime <= ISNULL([gad].[EndDateTime], [ts].[EndDateTime])
                )
        ORDER BY
            [ia].[StartDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get a list of alarms for an enhanced tele patient', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientAlarms';

