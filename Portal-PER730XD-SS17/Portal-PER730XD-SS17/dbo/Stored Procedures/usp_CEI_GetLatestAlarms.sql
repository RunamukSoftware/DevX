CREATE PROCEDURE [dbo].[usp_CEI_GetLatestAlarms]
    (
     @CutOffTimeUTC DATETIME,
     @locale VARCHAR(7) = 'en'
    )
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CutOffTimeUTC_arg DATETIME = @CutOffTimeUTC;
    DECLARE @locale_arg VARCHAR(7) = @locale;

    SELECT
        [AlarmId] = [AllAlarms].[AlarmId],
        [PatientId] = [v_PatientTopicSessions].[PatientId],
        [WaveformFeedTypeId] = [AllAlarms].[WaveformFeedTypeId],
        [StartDateTimeUTC] = [StartDateTime],
		[AcquiredDateTimeUTC] = [AcquiredDateTimeUTC],
        [Title] = ISNULL([Message], ISNULL([AlarmTypeName], N'')) + CASE WHEN [ValueFormat] IS NOT NULL THEN N' ' + REPLACE([ValueFormat], N'{0}', [ViolatingValue])
                                                                         ELSE N''
                                                                    END + CASE WHEN [LimitFormat] IS NOT NULL THEN N' ' + REPLACE([LimitFormat], N'{0}', [SettingViolated])
                                                                               ELSE N''
                                                                          END,
        [AlarmType] = [AlarmResources].[AlarmTypeName],
        [SettingViolated] = [AllAlarms].[SettingViolated],
        [ViolatingValue] = [AllAlarms].[ViolatingValue],
        [LegacyPriority] = CASE WHEN [PriorityWeightValue] = 0 THEN 0 -- none/message
                                WHEN [PriorityWeightValue] = 1 THEN 3 -- low
                                WHEN [PriorityWeightValue] = 2 THEN 2 -- medium
                                ELSE 1                                -- high
                           END,
        [SampleRate] = [TopicFeedTypes].[SampleRate],
        [organization_cd] = [DSIUnit].[Value],
        [ID1] = [int_mrn_map].[mrn_xid],
        [ID2] = [int_mrn_map].[mrn_xid2],
        [PatientName] = ISNULL([int_person].[last_nm], N'') + N', ' + ISNULL([int_person].[first_nm], N''),
        [BedName] = RTRIM([DSIBed].[Value])
    FROM
        (SELECT
            [AlarmId],
            [SettingViolated],
            [ViolatingValue],
            [StartDateTime],
			[AcquiredDateTimeUTC],
            [PriorityWeightValue],
            [WaveformFeedTypeId],
            [TopicSessionId],
            [IDEnumValue],
            [EnumGroupId]
         FROM
            [dbo].[LimitAlarmsData]
         WHERE
            @CutOffTimeUTC_arg < [LimitAlarmsData].[AcquiredDateTimeUTC]
         UNION ALL
         SELECT
            [AlarmId],
            [SettingViolated] = CAST(NULL AS VARCHAR(25)),
            [ViolatingValue] = CAST(NULL AS VARCHAR(25)),
            [StartDateTime],
			[AcquiredDateTimeUTC],
            [PriorityWeightValue],
            [WaveformFeedTypeId],
            [TopicSessionId],
            [IDEnumValue],
            [EnumGroupId]
         FROM
            [dbo].[GeneralAlarmsData]
         WHERE
            @CutOffTimeUTC_arg < [GeneralAlarmsData].[AcquiredDateTimeUTC]
        ) AS [AllAlarms]
        INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [AllAlarms].[TopicSessionId]
        INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [AllAlarms].[TopicSessionId]
        INNER JOIN [dbo].[AlarmResources] ON [AlarmResources].[Locale] = @locale_arg
                                             AND [AlarmResources].[EnumGroupId] = [AllAlarms].[EnumGroupId]
                                             AND [AlarmResources].[IDEnumValue] = [AllAlarms].[IDEnumValue]
        INNER JOIN [dbo].[int_mrn_map] ON [int_mrn_map].[patient_id] = [v_PatientTopicSessions].[PatientId] AND [int_mrn_map].[merge_cd]='C'
        INNER JOIN [dbo].[int_person] ON [int_person].[person_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[TopicFeedTypes] ON [TopicFeedTypes].[FeedTypeId] = [AllAlarms].[WaveformFeedTypeId]
        INNER JOIN [dbo].[v_DeviceSessionInfo] AS [DSIBed] ON [DSIBed].[DeviceSessionId] = [TopicSessions].[DeviceSessionId]
                                                              AND [DSIBed].[Name] = N'Bed'
        INNER JOIN [dbo].[v_DeviceSessionInfo] AS [DSIUnit] ON [DSIUnit].[DeviceSessionId] = [TopicSessions].[DeviceSessionId]
                                                               AND [DSIUnit].[Name] = N'Unit';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the latest Alarms for CEI.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetLatestAlarms';

