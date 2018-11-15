CREATE VIEW [dbo].[v_LimitAlarmsLite]
WITH
     SCHEMABINDING
AS
SELECT
    [EndAlarms].[AlarmId],
    [PatientId] AS [PatientId],
    [BeginAlarms].[SettingViolated], -- SETTING VIOLATED MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE as the setting may change since the time alarm was violated
    [BeginAlarms].[ViolatingValue], -- VIOLATED VALUE MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE. IT'S A BUSINESS REQUIREMENT.
    [EndAlarms].[IDEnumValue] AS [AlarmTypeId],
    [Enums].[Name] AS [AlarmType],
    [BeginAlarms].[PriorityWeightValue],
    [EndAlarms].[StartDateTime] AS [StartDateTimeUTC],
    [EndAlarms].[EndDateTime] AS [EndDateTimeUTC],
    [TopicSessions].[Id] AS [TopicSessionId],
    [TopicChannelCodes].[ChannelCode],
    [MDTopicLabel].[Value] AS [StrLabel],
    [EndAlarms].[Leads],
    [MDMessage].[PairValue] AS [StrMessage],
    [MDLimitFormat].[PairValue] AS [StrLimitFormat],
    [MDValueFormat].[PairValue] AS [StrValueFormat],
    [Removed]
FROM
    ( -- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
     SELECT
        [LimitAlarmsData].[AlarmId],
        [StartDateTime],
        [EndDateTime],
        [EnumGroupId],
        [IDEnumValue],
        [TopicSessionId],
        [Leads]
     FROM
        [dbo].[LimitAlarmsData]
        INNER JOIN (SELECT
                        [lad].[AlarmId],
                        MAX([lad].[AcquiredDateTimeUTC]) AS [AcquiredDateTimeUTC]
                    FROM
                        [dbo].[LimitAlarmsData] AS [lad]
                    GROUP BY
                        [lad].[AlarmId]
                   ) AS [MaxAlarms] ON [MaxAlarms].[AlarmId] = [LimitAlarmsData].[AlarmId]
                                       AND [LimitAlarmsData].[AcquiredDateTimeUTC] = [MaxAlarms].[AcquiredDateTimeUTC]
    ) AS [EndAlarms]
    INNER JOIN (  -- THE VERY FIRST UPDATE ON THE ALARM
                SELECT
                    [LimitAlarmsData].[AlarmId],
                    [TopicSessionId],
                    [ViolatingValue],
                    [SettingViolated],
                    [PriorityWeightValue]
                FROM
                    [dbo].[LimitAlarmsData]
                    INNER JOIN (SELECT
                                    [lad].[AlarmId],
                                    MIN([lad].[AcquiredDateTimeUTC]) AS [AcquiredDateTimeUTC]
                                FROM
                                    [dbo].[LimitAlarmsData] AS [lad]
                                GROUP BY
                                    [lad].[AlarmId]
                               ) AS [MinAlarms] ON [MinAlarms].[AlarmId] = [LimitAlarmsData].[AlarmId]
                                                   AND [LimitAlarmsData].[AcquiredDateTimeUTC] = [MinAlarms].[AcquiredDateTimeUTC]
               ) AS [BeginAlarms] ON [EndAlarms].[AlarmId] = [BeginAlarms].[AlarmId]
    INNER JOIN [dbo].[Enums] ON [GroupId] = [EndAlarms].[EnumGroupId]
                                AND [EndAlarms].[IDEnumValue] = [Enums].[Value]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [EndAlarms].[TopicSessionId]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
    LEFT OUTER JOIN [dbo].[RemovedAlarms] ON [RemovedAlarms].[AlarmId] = [EndAlarms].[AlarmId]
    LEFT OUTER JOIN (SELECT
                        [CorrespondingWaveformTypes].[TopicTypeId],
                        [AllTypes].[label],
                        [CorrespondingWaveformTypes].[ChannelCode]
                     FROM
                        [dbo].[v_LegacyChannelTypes] AS [AllTypes]
                        INNER JOIN -- here we need to select only topic types which means the type of the first waveform available on the topic, or just the type of the topic itself, if no waveform is available
                        (SELECT
                            [vlct].[TopicTypeId],
                            MIN([vlct].[ChannelCode]) AS [ChannelCode]
                         FROM
                            [dbo].[v_LegacyChannelTypes] AS [vlct]
                         GROUP BY
                            [vlct].[TopicTypeId]
                        ) AS [CorrespondingWaveformTypes] ON [CorrespondingWaveformTypes].[ChannelCode] = [AllTypes].[ChannelCode]
                                                             AND [CorrespondingWaveformTypes].[TopicTypeId] = [AllTypes].[TopicTypeId]
                    ) AS [TopicChannelCodes] ON [TopicChannelCodes].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN (SELECT
                        [EntityMemberName],
                        [PairValue],
                        [TopicTypeId]
                     FROM
                        [dbo].[v_MetaData]
                     WHERE
                        [EntityName] = 'LimitAlarms'
                        AND [PairName] = 'Message'
                    ) AS [MDMessage] ON [MDMessage].[EntityMemberName] = [Enums].[Name]
                                        AND [MDMessage].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN (SELECT
                        [EntityMemberName],
                        [PairValue],
                        [TopicTypeId]
                     FROM
                        [dbo].[v_MetaData]
                     WHERE
                        [EntityName] = 'LimitAlarms'
                        AND [PairName] = 'LimitFormat'
                    ) AS [MDLimitFormat] ON [MDLimitFormat].[EntityMemberName] = [Enums].[Name]
                                            AND [MDLimitFormat].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN (SELECT
                        [EntityMemberName],
                        [PairValue],
                        [TopicTypeId]
                     FROM
                        [dbo].[v_MetaData]
                     WHERE
                        [EntityName] = 'LimitAlarms'
                        AND [PairName] = 'ValueFormat'
                    ) AS [MDValueFormat] ON [MDValueFormat].[EntityMemberName] = [Enums].[Name]
                                            AND [MDValueFormat].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN [dbo].[v_MetaData] AS [MDTopicLabel] ON [MDTopicLabel].[TopicTypeId] = [TopicSessions].[TopicTypeId]
                                                            AND [MDTopicLabel].[EntityName] IS NULL
                                                            AND [MDTopicLabel].[Name] = 'Label';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LimitAlarmsLite';

