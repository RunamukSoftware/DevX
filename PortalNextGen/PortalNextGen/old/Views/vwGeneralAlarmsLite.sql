CREATE VIEW [old].[vwGeneralAlarmsLite]
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
        [EndAlarms].[PriorityWeightValue],
        [EndAlarms].StartDateTime AS [StartDateTime],
        [EndAlarms].[EndDateTime]   AS [EndDateTime],
        [ts].[TopicSessionID],
        [ts].[DeviceSessionID],
        [TopicChannelCodes].[ChannelCode],
        [MDTopicLabel].[Value]      AS [StrLabel],
        [EndAlarms].[AcquiredDateTime],
        [EndAlarms].[Leads],
        [MDMessage].[PairValue]     AS [StrMessage],
        [ra].[RemovedFlag]
    FROM
        ( -- GET THE LATEST ALARM DATA FROM THE LAST RECEIVED ALARM UPDATE
            SELECT
                [gad2].[GeneralAlarmID],
                [gad2].StartDateTime,
                [gad2].[EndDateTime],
                [gad2].[EnumGroupID],
                [gad2].[IDEnumValue],
                [gad2].[TopicSessionID],
                [gad2].[AcquiredDateTime],
                [gad2].[Leads],
                [gad2].[StatusValue],
                [gad2].[PriorityWeightValue]
            FROM
                [old].[GeneralAlarm] AS [gad2]
                INNER JOIN
                    (
                        SELECT
                            [gad].[GeneralAlarmID],
                            MAX([gad].[AcquiredDateTime]) AS [AcquiredDateTime]
                        FROM
                            [old].[GeneralAlarm] AS [gad]
                        GROUP BY
                            [gad].[GeneralAlarmID]
                    )                     AS [MaxAlarms]
                        ON [MaxAlarms].[GeneralAlarmID] = [gad2].[GeneralAlarmID]
                           AND [MaxAlarms].[AcquiredDateTime] = [gad2].[AcquiredDateTime]
        )                                  AS [EndAlarms]
        INNER JOIN
            [old].[Enum]                  AS [e]
                ON [e].[GroupID] = [EndAlarms].[EnumGroupID]
                   AND [EndAlarms].[IDEnumValue] = [e].[Value]
        LEFT OUTER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [EndAlarms].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[RemovedAlarm]          AS [ra]
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
                        )                        AS [CorrespondingWaveformTypes]
                            ON [CorrespondingWaveformTypes].[ChannelCode] = [AllTypes].[ChannelCode]
                               AND [CorrespondingWaveformTypes].[TopicTypeID] = [AllTypes].[TopicTypeID]
            )                              AS [TopicChannelCodes]
                ON [TopicChannelCodes].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            (
                SELECT
                    [vmd].[EntityMemberName],
                    [vmd].[PairValue],
                    [vmd].[TopicTypeID]
                FROM
                    [old].[vwMetadata] AS [vmd]
                WHERE
                    [vmd].[EntityName] = 'GeneralAlarms'
                    AND [vmd].[PairName] = 'Message'
            )                              AS [MDMessage]
                ON [MDMessage].[EntityMemberName] = [e].[Name]
                   AND [MDMessage].[TopicTypeID] = [ts].[TopicTypeID]
        LEFT OUTER JOIN
            [old].[vwMetadata]             AS [MDTopicLabel]
                ON [MDTopicLabel].[TopicTypeID] = [ts].[TopicTypeID]
                   AND [MDTopicLabel].[EntityName] IS NULL
                   AND [MDTopicLabel].[Name] = 'Label';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwGeneralAlarmsLite';

