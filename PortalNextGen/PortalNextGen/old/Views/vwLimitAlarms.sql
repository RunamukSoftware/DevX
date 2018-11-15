CREATE VIEW [old].[vwLimitAlarms]
WITH SCHEMABINDING
AS
    SELECT
        [EndAlarms].[LimitAlarmID],
        [vpts].[PatientID]          AS [PatientID],
        [BeginAlarms].[SettingViolated], -- SETTING VIOLATED MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE as the setting may change since the time alarm was violated
        [BeginAlarms].[ViolatingValue],  -- VIOLATED VALUE MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE. IT'S A BUSINESS REQUIREMENT.
        [EndAlarms].[IDEnumValue]   AS [AlarmTypeID],
        [e].[Name]                  AS [AlarmType],
        [EndAlarms].[StatusValue],
        [BeginAlarms].[PriorityWeightValue],
        [EndAlarms].StartDateTime AS [StartDateTime],
        [EndAlarms].[EndDateTime]   AS [EndDateTime],
        [ts].[TopicSessionID],
        [ts].[DeviceSessionID],
        [TopicChannelCodes].[ChannelCode],
        [MDTopicLabel].[Value]      AS [StrLabel],
        [BeginAlarms].[AcquiredDateTime],
        [EndAlarms].[Leads],
        [MDMessage].[PairValue]     AS [StrMessage],
        [MDLimitFormat].[PairValue] AS [StrLimitFormat],
        [MDValueFormat].[PairValue] AS [StrValueFormat],
        [ra].[RemovedFlag]
    FROM
        ( -- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
            SELECT
                [EndAlarmPackets].[LimitAlarmID],
                [EndAlarmPackets].StartDateTime,
                [EndAlarmPackets].[EndDateTime],
                [EndAlarmPackets].[EnumGroupID],
                [EndAlarmPackets].[IDEnumValue],
                [EndAlarmPackets].[TopicSessionID],
                [EndAlarmPackets].[Leads],
                [EndAlarmPackets].[StatusValue]
            FROM
                (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY
                                               [la].[LimitAlarmID]
                                           ORDER BY
                                               [la].[AcquiredDateTime] DESC
                                          ) AS [RowNumber],
                        [la].[LimitAlarmID],
                        [la].StartDateTime,
                        [la].[EndDateTime],
                        [la].[EnumGroupID],
                        [la].[IDEnumValue],
                        [la].[TopicSessionID],
                        [la].[Leads],
                        [la].[StatusValue]
                    FROM
                        [old].[LimitAlarm] AS [la]
                ) AS [EndAlarmPackets]
            WHERE
                [EndAlarmPackets].[RowNumber] = 1
        )                                  AS [EndAlarms]
        INNER JOIN
            ( -- THE VERY FIRST UPDATE ON THE ALARM
                SELECT
                    [StartAlarmPackets].[LimitAlarmID],
                    [StartAlarmPackets].[TopicSessionID],
                    [StartAlarmPackets].[ViolatingValue],
                    [StartAlarmPackets].[SettingViolated],
                    [StartAlarmPackets].[PriorityWeightValue],
                    [StartAlarmPackets].[AcquiredDateTime]
                FROM
                    (
                        SELECT
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [la2].[LimitAlarmID]
                                               ORDER BY
                                                   [la2].[AcquiredDateTime] ASC
                                              ) AS [RowNumber],
                            [la2].[LimitAlarmID],
                            [la2].[TopicSessionID],
                            [la2].[ViolatingValue],
                            [la2].[SettingViolated],
                            [la2].[PriorityWeightValue],
                            [la2].[AcquiredDateTime]
                        FROM
                            [old].[LimitAlarm] AS [la2]
                    ) AS [StartAlarmPackets]
                WHERE
                    [StartAlarmPackets].[RowNumber] = 1
            )                              AS [BeginAlarms]
                ON [EndAlarms].[LimitAlarmID] = [BeginAlarms].[LimitAlarmID]
        INNER JOIN
            [old].[Enum]                  AS [e]
                ON [e].[GroupID] = [EndAlarms].[EnumGroupID]
                   AND [EndAlarms].[IDEnumValue] = [e].[Value]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [EndAlarms].[TopicSessionID]
        LEFT OUTER JOIN
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Limit alarms view', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLimitAlarms';

