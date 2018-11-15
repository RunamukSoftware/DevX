CREATE PROCEDURE [CEI].[uspGetLatestAlarms]
    (
        @CutOffDateTime DATETIME2(7),
        @Locale         VARCHAR(7) = 'en'
    )
AS
    BEGIN
        SET NOCOUNT ON;

        --DECLARE @CutOffDateTime_arg DATETIME2(7) = @CutOffDateTime;
        --DECLARE @locale_arg VARCHAR(7) = @Locale;

        SELECT
                [AllAlarms].[LimitAlarmID]       AS [AlarmID],
                [vpts].[PatientID]               AS [PatientID],
                [AllAlarms].[WaveformFeedTypeID] AS [WaveformFeedTypeID],
                [AllAlarms].[StartDateTime]      AS [StartDateTime],
                [AllAlarms].[AcquiredDateTime]   AS [AcquiredDateTime],
                ISNULL([ar].[Message], ISNULL([ar].[AlarmTypeName], N''))
                + CASE
                      WHEN [ar].[ValueFormat] IS NOT NULL
                          THEN N' ' + REPLACE([ar].[ValueFormat], N'{0}', [AllAlarms].[ViolatingValue])
                      ELSE
                          N''
                  END + CASE
                            WHEN [ar].[LimitFormat] IS NOT NULL
                                THEN N' ' + REPLACE([ar].[LimitFormat], N'{0}', [AllAlarms].[SettingViolated])
                            ELSE
                                N''
                        END                      AS [Title],
                [ar].[AlarmTypeName]             AS [AlarmType],
                [AllAlarms].[SettingViolated]    AS [SettingViolated],
                [AllAlarms].[ViolatingValue]     AS [ViolatingValue],
                CASE
                    WHEN [AllAlarms].[PriorityWeightValue] = 0
                        THEN 0 -- none/message
                    WHEN [AllAlarms].[PriorityWeightValue] = 1
                        THEN 3 -- low
                    WHEN [AllAlarms].[PriorityWeightValue] = 2
                        THEN 2 -- medium
                    ELSE
                        1      -- high
                END                              AS [LegacyPriority],
                [tft].[SampleRate]               AS [SampleRate],
                [DSIUnit].[Value]                AS [OrganizationCode],
                [imm].[MedicalRecordNumberXID]   AS [ID1],
                [imm].[MedicalRecordNumberXID2]  AS [ID2],
                [ipe].[FirstName],
                [ipe].[LastName],
                RTRIM([DSIBed].[Value])          AS [BedName]
        FROM
                (
                    SELECT
                        [la].[LimitAlarmID],
                        [la].[SettingViolated],
                        [la].[ViolatingValue],
                        [la].[StartDateTime],
                        [la].[AcquiredDateTime],
                        [la].[PriorityWeightValue],
                        [la].[WaveformFeedTypeID],
                        [la].[TopicSessionID],
                        [la].[IDEnumValue],
                        [la].[EnumGroupID]
                    FROM
                        [old].[LimitAlarm] AS [la]
                    WHERE
                        @CutOffDateTime < [la].[AcquiredDateTime]
                    UNION ALL
                    SELECT
                        [gad].[GeneralAlarmID],
                        CAST(NULL AS VARCHAR(25)) AS [SettingViolated],
                        CAST(NULL AS VARCHAR(25)) AS [ViolatingValue],
                        [gad].[StartDateTime],
                        [gad].[AcquiredDateTime],
                        [gad].[PriorityWeightValue],
                        [gad].[WaveformFeedTypeID],
                        [gad].[TopicSessionID],
                        [gad].[IDEnumValue],
                        [gad].[EnumGroupID]
                    FROM
                        [old].[GeneralAlarm] AS [gad]
                    WHERE
                        @CutOffDateTime < [gad].[AcquiredDateTime]
                )                                  AS [AllAlarms]
            INNER JOIN
                [old].[vwPatientTopicSessions]     AS [vpts]
                    ON [vpts].[TopicSessionID] = [AllAlarms].[TopicSessionID]
            INNER JOIN
                [old].[TopicSession]               AS [ts]
                    ON [ts].[TopicSessionID] = [AllAlarms].[TopicSessionID]
            INNER JOIN
                [old].[AlarmResource]              AS [ar]
                    ON [ar].[Locale] = @Locale
                       AND [ar].[EnumGroupID] = [AllAlarms].[EnumGroupID]
                       AND [ar].[IDEnumValue] = [AllAlarms].[IDEnumValue]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [imm].[PatientID] = [vpts].[PatientID]
                       AND [imm].[MergeCode] = 'C'
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [imm].[PatientID]
            INNER JOIN
                [old].[FeedType]                   AS [tft]
                    ON [tft].[FeedTypeID] = [AllAlarms].[WaveformFeedTypeID]
            INNER JOIN
                [old].[vwDeviceSessionInfo]        AS [DSIBed]
                    ON [DSIBed].[DeviceSessionID] = [ts].[DeviceSessionID]
                       AND [DSIBed].[Name] = N'Bed'
            INNER JOIN
                [old].[vwDeviceSessionInfo]        AS [DSIUnit]
                    ON [DSIUnit].[DeviceSessionID] = [ts].[DeviceSessionID]
                       AND [DSIUnit].[Name] = N'Unit';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the latest Alarms for CEI.', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetLatestAlarms';

