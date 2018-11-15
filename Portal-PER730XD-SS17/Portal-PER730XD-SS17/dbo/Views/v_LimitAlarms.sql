CREATE VIEW [dbo].[v_LimitAlarms]
WITH
     SCHEMABINDING
AS
SELECT
    [EndAlarms].[AlarmId],
    [vpts].[PatientId] AS [PatientId],
    [BeginAlarms].[SettingViolated], -- SETTING VIOLATED MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE as the setting may change since the time alarm was violated
    [BeginAlarms].[ViolatingValue], -- VIOLATED VALUE MUST BE TAKEN FROM THE VERY FIRST ALARM UPDATE. IT'S A BUSINESS REQUIREMENT.
    [IDEnumValue] AS [AlarmTypeId],
    [Enums].[Name] AS [AlarmType],
    [EndAlarms].[StatusValue],
    [PriorityWeightValue],
    [EndAlarms].[StartDateTime] AS [StartDateTimeUTC],
    [EndAlarms].[EndDateTime] AS [EndDateTimeUTC],
    [TopicSessions].[Id] AS [TopicSessionId],
    [TopicSessions].[DeviceSessionId],
    [TopicChannelCodes].[ChannelCode],
    [MDTopicLabel].[Value] AS [StrLabel],
    [BeginAlarms].[AcquiredDateTimeUTC],
    [EndAlarms].[Leads],
    [MDMessage].[PairValue] AS [StrMessage],
    [MDLimitFormat].[PairValue] AS [StrLimitFormat],
    [MDValueFormat].[PairValue] AS [StrValueFormat],
    [Removed]
FROM
    ( -- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
     SELECT
        [AlarmId],
        [StartDateTime],
        [EndDateTime],
        [EnumGroupId],
        [IDEnumValue],
        [TopicSessionId],
        [Leads],
        [StatusValue]
     FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [AlarmId] ORDER BY [AcquiredDateTimeUTC] DESC) AS [RowNumber],
            [AlarmId],
            [StartDateTime],
            [EndDateTime],
            [EnumGroupId],
            [IDEnumValue],
            [TopicSessionId],
            [Leads],
            [StatusValue]
         FROM
            [dbo].[LimitAlarmsData]
        ) AS [EndAlarmPackets]
     WHERE
        [EndAlarmPackets].[RowNumber] = 1
    ) AS [EndAlarms]
    INNER JOIN (  -- THE VERY FIRST UPDATE ON THE ALARM
                SELECT
                    [AlarmId],
                    [TopicSessionId],
                    [ViolatingValue],
                    [SettingViolated],
                    [PriorityWeightValue],
                    [AcquiredDateTimeUTC]
                FROM
                    (SELECT
                        ROW_NUMBER() OVER (PARTITION BY [AlarmId] ORDER BY [AcquiredDateTimeUTC] ASC) AS [RowNumber],
                        [AlarmId],
                        [TopicSessionId],
                        [ViolatingValue],
                        [SettingViolated],
                        [PriorityWeightValue],
                        [AcquiredDateTimeUTC]
                     FROM
                        [dbo].[LimitAlarmsData]
                    ) AS [StartAlarmPackets]
                WHERE
                    [StartAlarmPackets].[RowNumber] = 1
               ) AS [BeginAlarms] ON [EndAlarms].[AlarmId] = [BeginAlarms].[AlarmId]
    INNER JOIN [dbo].[Enums] ON [Enums].[GroupId] = [EndAlarms].[EnumGroupId]
                                AND [EndAlarms].[IDEnumValue] = [Enums].[Value]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [EndAlarms].[TopicSessionId]
    LEFT OUTER JOIN [dbo].[v_PatientTopicSessions] AS [vpts] ON [vpts].[TopicSessionId] = [TopicSessions].[Id]
    LEFT OUTER JOIN [dbo].[RemovedAlarms] ON [RemovedAlarms].[AlarmId] = [EndAlarms].[AlarmId]
    LEFT OUTER JOIN (SELECT
                        [CorrespondingWaveformTypes].[TopicTypeId],
                        [label],
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
                                                            AND [EntityName] IS NULL
                                                            AND [MDTopicLabel].[Name] = 'Label';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Limit alarms view', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LimitAlarms';

