CREATE PROCEDURE [dbo].[GetPatientAlarms]
    (
    @patient_id UNIQUEIDENTIFIER,
    @start_ft BIGINT,
    @end_ft BIGINT,
    @locale VARCHAR(7) = 'en')
AS
BEGIN
    DECLARE
        @end_dt DATETIME = [dbo].[fnFileTimeToDateTime](@end_ft),
        @start_dt DATETIME = [dbo].[fnFileTimeToDateTime](@start_ft),
        @locale_arg VARCHAR(7) = @locale,
        @patient_id_arg UNIQUEIDENTIFIER = @patient_id;

    SELECT
        [alarm_id] AS [Id],
        [int_channel_type].[channel_code] AS [TYPE],
        ISNULL([alarm_cd], N'') AS [TypeString],
        ISNULL([alarm_cd], N'') AS [TITLE],
        [start_ft] AS [start_ft],
        [end_ft] AS [end_ft],
        [start_dt] AS [START_DT],
        [removed] AS [Removed],
        [alarm_level] AS [priority],
        CAST(N'' AS NVARCHAR(250)) AS [Label]
    FROM [dbo].[int_alarm]
        INNER JOIN [dbo].[int_patient_channel]
            ON [int_alarm].[patient_channel_id] = [int_patient_channel].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type]
            ON [int_patient_channel].[channel_type_id] = [int_channel_type].[channel_type_id]
    WHERE [int_alarm].[patient_id] = @patient_id_arg
          AND [alarm_level] > 0
          AND (@start_ft < [int_alarm].[end_ft]
               OR [int_alarm].[end_ft] IS NULL)
    UNION ALL
    SELECT
        [LimitAlarmsData].[AlarmId] AS [Id],
        [TopicFeedTypes].[ChannelCode] AS [TYPE],
        ISNULL([Message], [AlarmTypeName]) AS [TypeString],
        ISNULL([Message], N'') + '  ' + REPLACE(ISNULL([ValueFormat], ''), '{0}', [ViolatingValue]) + '  '
        + REPLACE(ISNULL([LimitFormat], N''), '{0}', [SettingViolated]) AS [Title],
        [start_ft].[FileTime] AS [start_ft],
        [end_ft].[FileTime] AS [end_ft],
        CAST(NULL AS DATETIME) AS [START_DT],
        [Removed],
        CASE
            WHEN [PriorityWeightValue] = 0
                THEN 0 -- none/message
            WHEN [PriorityWeightValue] = 1
                THEN 3 -- low
            WHEN [PriorityWeightValue] = 2
                THEN 2 -- medium
            ELSE
                1      -- high
        END AS [priority],
        CAST(N'' AS NVARCHAR(250)) AS [Label]
    FROM [dbo].[LimitAlarmsData]
        INNER JOIN [dbo].[AlarmResources]
            ON [AlarmResources].[EnumGroupId] = [LimitAlarmsData].[EnumGroupId]
               AND [AlarmResources].[IDEnumValue] = [LimitAlarmsData].[IDEnumValue]
               AND [AlarmResources].[Locale] = @locale_arg
        INNER JOIN [dbo].[TopicFeedTypes]
            ON [TopicFeedTypes].[FeedTypeId] = [LimitAlarmsData].[WaveformFeedTypeId]
        INNER JOIN [dbo].[v_PatientTopicSessions]
            ON [v_PatientTopicSessions].[TopicSessionId] = [LimitAlarmsData].[TopicSessionId]
        INNER JOIN [dbo].[TopicSessions]
            ON [TopicSessions].[Id] = [LimitAlarmsData].[TopicSessionId]
        LEFT OUTER JOIN [dbo].[RemovedAlarms]
            ON [RemovedAlarms].[AlarmId] = [LimitAlarmsData].[AlarmId]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([StartDateTime]) AS [start_ft]
        CROSS APPLY [dbo].[fntDateTimeToFileTime](ISNULL([EndDateTime], [TopicSessions].[EndTimeUTC])) AS [end_ft]
    WHERE [v_PatientTopicSessions].[PatientId] = @patient_id_arg
          AND [StartDateTime] <= @end_dt
          AND (([EndDateTime] IS NULL
                AND [TopicSessions].[EndTimeUTC] IS NULL)
               OR @start_dt <= ISNULL([EndDateTime], [TopicSessions].[EndTimeUTC]))
    UNION ALL
    SELECT
        [GeneralAlarmsData].[AlarmId] AS [Id],
        [TopicFeedTypes].[ChannelCode] AS [TYPE],
        ISNULL([Message], [AlarmTypeName]) AS [TypeString],
        ISNULL([Message], N'') AS [Title],
        [start_ft].[FileTime] AS [start_ft],
        [end_ft].[FileTime] AS [end_ft],
        CAST(NULL AS DATETIME) AS [START_DT],
        [Removed],
        CASE
            WHEN [PriorityWeightValue] = 0
                THEN 0 -- none/message
            WHEN [PriorityWeightValue] = 1
                THEN 3 -- low
            WHEN [PriorityWeightValue] = 2
                THEN 2 -- medium
            ELSE
                1      -- high
        END AS [priority],
        CAST(N'' AS NVARCHAR(250)) AS [Label]
    FROM [dbo].[GeneralAlarmsData]
        INNER JOIN [dbo].[AlarmResources]
            ON [AlarmResources].[EnumGroupId] = [GeneralAlarmsData].[EnumGroupId]
               AND [AlarmResources].[IDEnumValue] = [GeneralAlarmsData].[IDEnumValue]
               AND [AlarmResources].[Locale] = @locale_arg
        INNER JOIN [dbo].[TopicFeedTypes]
            ON [TopicFeedTypes].[FeedTypeId] = [GeneralAlarmsData].[WaveformFeedTypeId]
        INNER JOIN [dbo].[v_PatientTopicSessions]
            ON [v_PatientTopicSessions].[TopicSessionId] = [GeneralAlarmsData].[TopicSessionId]
        INNER JOIN [dbo].[TopicSessions]
            ON [TopicSessions].[Id] = [GeneralAlarmsData].[TopicSessionId]
        LEFT OUTER JOIN [dbo].[RemovedAlarms]
            ON [RemovedAlarms].[AlarmId] = [GeneralAlarmsData].[AlarmId]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([StartDateTime]) AS [start_ft]
        CROSS APPLY [dbo].[fntDateTimeToFileTime](ISNULL([EndDateTime], [TopicSessions].[EndTimeUTC])) AS [end_ft]
    WHERE [v_PatientTopicSessions].[PatientId] = @patient_id_arg
          AND [StartDateTime] <= @end_dt
          AND (([EndDateTime] IS NULL
                AND [TopicSessions].[EndTimeUTC] IS NULL)
               OR @start_dt <= ISNULL([EndDateTime], [TopicSessions].[EndTimeUTC]))
    ORDER BY [start_ft] DESC;
END;
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Get a list of alarms for an enhanced tele patient',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'PROCEDURE',
    @level1name = N'GetPatientAlarms';
