CREATE VIEW [old].[vwLimitAlarmsLite]
WITH SCHEMABINDING
AS
    SELECT
        [EndAlarms].[LimitAlarmID],
        [vpts].[PatientID]          AS [PatientID],
        [BeginAlarms].[SettingViolated], -- SETTING VIOLATED MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE as the setting may change since the time alarm was violated
        [BeginAlarms].[ViolatingValue],  -- VIOLATED VALUE MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE. IT'S A BUSINESS REQUIREMENT.
        [EndAlarms].[IDEnumValue]   AS [AlarmTypeID],
        [e].[Name]                  AS [AlarmType],
        [BeginAlarms].[PriorityWeightValue],
        [EndAlarms].StartDateTime AS [StartDateTime],
        [EndAlarms].[EndDateTime]   AS [EndDateTime],
        [ts].[TopicSessionID],
        [TopicChannelCodes].[ChannelCode],
        [MDTopicLabel].[Value]      AS [StrLabel],
        [EndAlarms].[Leads],
        [MDMessage].[PairValue]     AS [StrMessage],
        [MDLimitFormat].[PairValue] AS [StrLimitFormat],
        [MDValueFormat].[PairValue] AS [StrValueFormat],
        [ra].[RemovedFlag]
    FROM
        ( -- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
            SELECT
                [la2].[LimitAlarmID],
                [la2].StartDateTime,
                [la2].[EndDateTime],
                [la2].[EnumGroupID],
                [la2].[IDEnumValue],
                [la2].[TopicSessionID],
                [la2].[Leads]
            FROM
                [old].[LimitAlarm] AS [la2]
                INNER JOIN
                    (
                        SELECT
                            [la].[LimitAlarmID],
                            MAX([la].[AcquiredDateTime]) AS [AcquiredDateTime]
                        FROM
                            [old].[LimitAlarm] AS [la]
                        GROUP BY
                            [la].[LimitAlarmID]
                    )              AS [MaxAlarms]
                        ON [MaxAlarms].[LimitAlarmID] = [la2].[LimitAlarmID]
                           AND [la2].[AcquiredDateTime] = [MaxAlarms].[AcquiredDateTime]
        )                                  AS [EndAlarms]
        INNER JOIN
            ( -- THE VERY FIRST UPDATE ON THE ALARM
                SELECT
                    [la3].[LimitAlarmID],
                    [la3].[TopicSessionID],
                    [la3].[ViolatingValue],
                    [la3].[SettingViolated],
                    [la3].[PriorityWeightValue]
                FROM
                    [old].[LimitAlarm] AS [la3]
                    INNER JOIN
                        (
                            SELECT
                                [la].[LimitAlarmID],
                                MIN([la].[AcquiredDateTime]) AS [AcquiredDateTime]
                            FROM
                                [old].[LimitAlarm] AS [la]
                            GROUP BY
                                [la].[LimitAlarmID]
                        )              AS [MinAlarms]
                            ON [MinAlarms].[LimitAlarmID] = [la3].[LimitAlarmID]
                               AND [la3].[AcquiredDateTime] = [MinAlarms].[AcquiredDateTime]
            )                              AS [BeginAlarms]
                ON [EndAlarms].[LimitAlarmID] = [BeginAlarms].[LimitAlarmID]
        INNER JOIN
            [old].[Enum]                  AS [e]
                ON [e].[GroupID] = [EndAlarms].[EnumGroupID]
                   AND [EndAlarms].[IDEnumValue] = [e].[Value]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [EndAlarms].[TopicSessionID]
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[RemovedAlarm]          AS [ra]
                ON [ra].[AlarmID] = [EndAlarms].[LimitAlarmID]
        LEFT OUTER JOIN
            (
                SELECT
                    [CorrespondingWaveformTypes].[TopicTypeID],
                    [AllTypes].[Label],
                    [CorrespondingWaveformTypes].[ChannelCode]
                FROM
                    [old].[vwLegacyChannelTypes] AS [AllTypes]
                    INNER JOIN -- here we need to select only topic types which means the Type of the first waveform available on the topic, or just the Type of the topic itself, if no waveform is available
                        (
                            SELECT
                                [vlct].[TopicTypeID],
                                MIN([vlct].[ChannelCode]) AS [ChannelCode]
                            FROM
                                [old].[vwLegacyChannelTypes] AS [vlct]
                            GROUP BY
                                [vlct].[TopicTypeID]
                        )                        AS [CorrespondingWaveformTypes]
                            ON [CorrespondingWaveformTypes].[ChannelCode] = [AllTypes].[ChannelCode]
                               AND [CorrespondingWaveformTypes].[TopicTypeID] = [AllTypes].[TopicTypeID]
            )                              AS [TopicChannelCodes]
                ON [TopicChannelCodes].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [vm].[EntityMemberName],
                    [vm].[PairValue],
                    [vm].[TopicTypeID]
                FROM
                    [old].[vwMetadata] AS [vm]
                WHERE
                    [vm].[EntityName] = 'LimitAlarms'
                    AND [vm].[PairName] = 'Message'
            )                              AS [MDMessage]
                ON [MDMessage].[EntityMemberName] = [e].[Name]
                   AND [MDMessage].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [vm2].[EntityMemberName],
                    [vm2].[PairValue],
                    [vm2].[TopicTypeID]
                FROM
                    [old].[vwMetadata] AS [vm2]
                WHERE
                    [vm2].[EntityName] = 'LimitAlarms'
                    AND [vm2].[PairName] = 'LimitFormat'
            )                              AS [MDLimitFormat]
                ON [MDLimitFormat].[EntityMemberName] = [e].[Name]
                   AND [MDLimitFormat].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [vm3].[EntityMemberName],
                    [vm3].[PairValue],
                    [vm3].[TopicTypeID]
                FROM
                    [old].[vwMetadata] AS [vm3]
                WHERE
                    [vm3].[EntityName] = 'LimitAlarms'
                    AND [vm3].[PairName] = 'ValueFormat'
            )                              AS [MDValueFormat]
                ON [MDValueFormat].[EntityMemberName] = [e].[Name]
                   AND [MDValueFormat].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            [old].[vwMetadata]             AS [MDTopicLabel]
                ON [MDTopicLabel].[TopicTypeID] = [ts].[TopicTypeID]
                   AND [MDTopicLabel].[EntityName] IS NULL
                   AND [MDTopicLabel].[Name] = 'Label';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLimitAlarmsLite';

