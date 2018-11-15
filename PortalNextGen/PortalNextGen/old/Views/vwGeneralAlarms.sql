CREATE VIEW [old].[vwGeneralAlarms]
WITH SCHEMABINDING
AS
    SELECT
            [EndAlarms].[GeneralAlarmID],
            [vpts].[PatientID]          AS [PatientID],
            [EndAlarms].[IDEnumValue]   AS [AlarmTypeID],
            [e].[Name]                  AS [AlarmType],
            [e].[Name]                  AS [Title],
            [EndAlarms].[EnumGroupID],
            [EndAlarms].[StatusValue],
            [BeginAlarms].[PriorityWeightValue], -- Priority weight value must be taken from the very first alarm update, as the final one resets the priority
            [EndAlarms].[StartDateTime] AS [StartDateTime],
            [EndAlarms].[EndDateTime]   AS [EndDateTime],
            [ts].[TopicSessionID],
            [ts].[DeviceSessionID],
            [TopicChannelCodes].[ChannelCode],
            [MDTopicLabel].[Value]      AS [StrLabel],
            [BeginAlarms].[AcquiredDateTime],
            [EndAlarms].[Leads],
            [MDMessage].[PairValue]     AS [StrMessage],
            [ra].[RemovedFlag]
    FROM
            ( -- Get the latest alarm data from the last received alarm update
                SELECT
                    [EndAlarmPackets].[GeneralAlarmID],
                    [EndAlarmPackets].[StartDateTime],
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
                                                   [gad].[GeneralAlarmID]
                                               ORDER BY
                                                   [gad].[AcquiredDateTime] DESC
                                              ) AS [RowNumber],
                            [gad].[GeneralAlarmID],
                            [gad].[StartDateTime],
                            [gad].[EndDateTime],
                            [gad].[EnumGroupID],
                            [gad].[IDEnumValue],
                            [gad].[TopicSessionID],
                            [gad].[Leads],
                            [gad].[StatusValue]
                        FROM
                            [old].[GeneralAlarm] AS [gad]
                    ) AS [EndAlarmPackets]
                WHERE
                    [EndAlarmPackets].[RowNumber] = 1
            )                              AS [EndAlarms]
        INNER JOIN
            ( -- The very first update on the alarm 
                SELECT
                    [StartAlarmPackets].[GeneralAlarmID],
                    [StartAlarmPackets].[PriorityWeightValue],
                    [StartAlarmPackets].[AcquiredDateTime]
                FROM
                    (
                        SELECT
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [gad2].[GeneralAlarmID]
                                               ORDER BY
                                                   [gad2].[AcquiredDateTime] ASC
                                              ) AS [RowNumber],
                            [gad2].[GeneralAlarmID],
                            [gad2].[AcquiredDateTime],
                            [gad2].[PriorityWeightValue]
                        FROM
                            [old].[GeneralAlarm] AS [gad2]
                    ) AS [StartAlarmPackets]
                WHERE
                    [StartAlarmPackets].[RowNumber] = 1
            )                              AS [BeginAlarms]
                ON [EndAlarms].[GeneralAlarmID] = [BeginAlarms].[GeneralAlarmID]
        INNER JOIN
            [old].[Enum]                   AS [e]
                ON [e].[GroupID] = [EndAlarms].[EnumGroupID]
                   AND [EndAlarms].[IDEnumValue] = [e].[Value]
        LEFT OUTER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [EndAlarms].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[RemovedAlarm]           AS [ra]
                ON [ra].[AlarmID] = [EndAlarms].[GeneralAlarmID]
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
                        )                            AS [CorrespondingWaveformTypes]
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
                    [vm].[EntityName] = 'GeneralAlarms'
                    AND [vm].[PairName] = 'Message'
            )                              AS [MDMessage]
                ON [MDMessage].[EntityMemberName] = [e].[Name]
                   AND [MDMessage].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            [old].[vwMetadata]             AS [MDTopicLabel]
                ON [MDTopicLabel].[TopicTypeID] = [ts].[TopicTypeID]
                   AND [MDTopicLabel].[EntityName] IS NULL
                   AND [MDTopicLabel].[Name] = 'Label';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwGeneralAlarms';

