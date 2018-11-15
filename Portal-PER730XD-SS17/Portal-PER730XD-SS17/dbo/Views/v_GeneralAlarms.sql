CREATE VIEW [dbo].[v_GeneralAlarms]
WITH
     SCHEMABINDING
AS
SELECT
    [EndAlarms].[AlarmId],
    [PatientId] AS [PatientId],
    [EndAlarms].[IDEnumValue] AS [AlarmTypeId],
    [Enums].[Name] AS [AlarmType],
    [Enums].[Name] AS [Title],
    [EndAlarms].[EnumGroupId],
    [EndAlarms].[StatusValue],
    [BeginAlarms].[PriorityWeightValue], -- Priority weight value must be taken from the very first alarm update, as the final one resets the priority
    [EndAlarms].[StartDateTime] AS [StartDateTimeUTC],
    [EndAlarms].[EndDateTime] AS [EndDateTimeUTC],
    [TopicSessions].[Id] AS [TopicSessionId],
    [DeviceSessionId],
    [TopicChannelCodes].[ChannelCode],
    [MDTopicLabel].[Value] AS [StrLabel],
    [BeginAlarms].[AcquiredDateTimeUTC],
    [EndAlarms].[Leads],
    [MDMessage].[PairValue] AS [StrMessage],
    [Removed]
FROM
    (-- Get the latest alarm data from the last received alarm update
     SELECT
        [EndAlarmPackets].[AlarmId],
        [EndAlarmPackets].[StartDateTime],
        [EndAlarmPackets].[EndDateTime],
        [EndAlarmPackets].[EnumGroupId],
        [EndAlarmPackets].[IDEnumValue],
        [EndAlarmPackets].[TopicSessionId],
        [EndAlarmPackets].[Leads],
        [EndAlarmPackets].[StatusValue]
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
            [dbo].[GeneralAlarmsData]
        ) AS [EndAlarmPackets]
     WHERE
        [EndAlarmPackets].[RowNumber] = 1
    ) AS [EndAlarms]
    INNER JOIN ( -- The very first update on the alarm 
                SELECT
                    [StartAlarmPackets].[AlarmId],
                    [StartAlarmPackets].[PriorityWeightValue],
                    [StartAlarmPackets].[AcquiredDateTimeUTC]
                FROM
                    (SELECT
                        ROW_NUMBER() OVER (PARTITION BY [AlarmId] ORDER BY [AcquiredDateTimeUTC] ASC) AS [RowNumber],
                        [AlarmId],
                        [AcquiredDateTimeUTC],
                        [PriorityWeightValue]
                     FROM
                        [dbo].[GeneralAlarmsData]
                    ) AS [StartAlarmPackets]
                WHERE
                    [StartAlarmPackets].[RowNumber] = 1
               ) AS [BeginAlarms] ON [EndAlarms].[AlarmId] = [BeginAlarms].[AlarmId]
    INNER JOIN [dbo].[Enums] ON [GroupId] = [EndAlarms].[EnumGroupId]
                                AND [EndAlarms].[IDEnumValue] = [Enums].[Value]
    LEFT OUTER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [EndAlarms].[TopicSessionId]
    LEFT OUTER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id]
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
                        [EntityName] = 'GeneralAlarms'
                        AND [PairName] = 'Message'
                    ) AS [MDMessage] ON [MDMessage].[EntityMemberName] = [Enums].[Name]
                                        AND [MDMessage].[TopicTypeId] = [TopicSessions].[TopicTypeId]
    LEFT OUTER JOIN [dbo].[v_MetaData] AS [MDTopicLabel] ON [MDTopicLabel].[TopicTypeId] = [TopicSessions].[TopicTypeId]
                                                            AND [MDTopicLabel].[EntityName] IS NULL
                                                            AND [MDTopicLabel].[Name] = 'Label';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_GeneralAlarms';

