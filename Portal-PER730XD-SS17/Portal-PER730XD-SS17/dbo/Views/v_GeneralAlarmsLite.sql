CREATE VIEW [dbo].[v_GeneralAlarmsLite]
WITH
     SCHEMABINDING
AS
SELECT
    [EndAlarms].[AlarmId],
    [v_PatientTopicSessions].[PatientId] AS [PatientId],
    [IDEnumValue] AS [AlarmTypeId],
    [Enums].[Name] AS [AlarmType],
    [Enums].[Name] AS [Title],
    [EnumGroupId],
    [EndAlarms].[StatusValue],
    [EndAlarms].[PriorityWeightValue],
    [EndAlarms].[StartDateTime] AS [StartDateTimeUTC],
    [EndAlarms].[EndDateTime] AS [EndDateTimeUTC],
    [TopicSessions].[Id] AS [TopicSessionId],
    [TopicSessions].[DeviceSessionId],
    [TopicChannelCodes].[ChannelCode],
    [MDTopicLabel].[Value] AS [StrLabel],
    [EndAlarms].[AcquiredDateTimeUTC],
    [EndAlarms].[Leads],
    [MDMessage].[PairValue] AS [StrMessage],
    [Removed]
FROM
    (-- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
     SELECT
        [GeneralAlarmsData].[AlarmId],
        [StartDateTime],
        [EndDateTime],
        [EnumGroupId],
        [IDEnumValue],
        [TopicSessionId],
        [GeneralAlarmsData].[AcquiredDateTimeUTC],
        [Leads],
        [StatusValue],
        [PriorityWeightValue]
     FROM
        [dbo].[GeneralAlarmsData]
        INNER JOIN (SELECT
                        [AlarmId],
                        MAX([gad].[AcquiredDateTimeUTC]) AS [AcquiredDateTimeUTC]
                    FROM
                        [dbo].[GeneralAlarmsData] AS [gad]
                    GROUP BY
                        [AlarmId]
                   ) AS [MaxAlarms] ON [MaxAlarms].[AlarmId] = [GeneralAlarmsData].[AlarmId]
                                       AND [MaxAlarms].[AcquiredDateTimeUTC] = [GeneralAlarmsData].[AcquiredDateTimeUTC]
    ) AS [EndAlarms]
    INNER JOIN [dbo].[Enums] ON [Enums].[GroupId] = [EndAlarms].[EnumGroupId]
                                AND [EndAlarms].[IDEnumValue] = [Enums].[Value]
    LEFT OUTER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [EndAlarms].[TopicSessionId]
    LEFT OUTER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
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
                        [vmd].[EntityMemberName],
                        [vmd].[PairValue],
                        [vmd].[TopicTypeId]
                     FROM
                        [dbo].[v_MetaData] AS [vmd]
                     WHERE
                        [vmd].[EntityName] = 'GeneralAlarms'
                        AND [vmd].[PairName] = 'Message'
                    ) AS [MDMessage] ON [MDMessage].[EntityMemberName] = [Enums].[Name]
                                        AND [MDMessage].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN [dbo].[v_MetaData] AS [MDTopicLabel] ON [MDTopicLabel].[TopicTypeId] = [TopicSessions].[TopicTypeId]
                                                            AND [EntityName] IS NULL
                                                            AND [MDTopicLabel].[Name] = 'Label';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_GeneralAlarmsLite';

