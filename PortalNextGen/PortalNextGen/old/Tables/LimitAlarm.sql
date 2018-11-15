CREATE TABLE [old].[LimitAlarm] (
    [LimitAlarmID]        INT           IDENTITY (1, 1) NOT NULL,
    [SettingViolated]     VARCHAR (25)  NOT NULL,
    [ViolatingValue]      VARCHAR (25)  NOT NULL,
    [StartDateTime]       DATETIME2 (7) NOT NULL,
    [EndDateTime]         DATETIME2 (7) NULL,
    [StatusValue]         INT           NOT NULL,
    [DetectionTimestamp]  DATETIME2 (7) NOT NULL,
    [Acknowledged]        BIT           NOT NULL,
    [PriorityWeightValue] INT           NOT NULL,
    [AcquiredDateTime]    DATETIME2 (7) NOT NULL,
    [Leads]               INT           NOT NULL,
    [WaveformFeedTypeID]  INT           NOT NULL,
    [TopicSessionID]      INT           NOT NULL,
    [FeedTypeID]          INT           NOT NULL,
    [IDEnumValue]         INT           NOT NULL,
    [EnumGroupID]         INT           NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_LimitAlarm_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_LimitAlarmsData_LimitAlarmID] PRIMARY KEY CLUSTERED ([LimitAlarmID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_LimitAlarm_FeedType_FeedTypeID] FOREIGN KEY ([FeedTypeID]) REFERENCES [old].[FeedType] ([FeedTypeID]),
    CONSTRAINT [FK_LimitAlarm_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LimitAlarmsData_TopicSessionID_StartDateTime_EndDateTime_PriorityWeightValueIDEnumValue]
    ON [old].[LimitAlarm]([TopicSessionID] ASC, [StartDateTime] ASC, [EndDateTime] ASC, [PriorityWeightValue] ASC, [IDEnumValue] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_TopicSessionID_StartDateTime_INCLUDES]
    ON [old].[LimitAlarm]([TopicSessionID] ASC, [StartDateTime] ASC)
    INCLUDE([LimitAlarmID], [SettingViolated], [ViolatingValue], [EndDateTime], [PriorityWeightValue], [WaveformFeedTypeID], [IDEnumValue], [EnumGroupID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_EndDateTime_TopicSessionID_LimitAlarmID]
    ON [old].[LimitAlarm]([EndDateTime] ASC, [TopicSessionID] ASC)
    INCLUDE([LimitAlarmID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_StartDateTime_AlarmId_SettingViolated_ViolatingValue_EndDateTime_PriorityWeightValue_INCLUDES]
    ON [old].[LimitAlarm]([StartDateTime] ASC)
    INCLUDE([LimitAlarmID], [SettingViolated], [ViolatingValue], [EndDateTime], [PriorityWeightValue], [WaveformFeedTypeID], [TopicSessionID], [IDEnumValue], [EnumGroupID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_StartDateTime]
    ON [old].[LimitAlarm]([StartDateTime] DESC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_AlarmID]
    ON [old].[LimitAlarm]([LimitAlarmID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE TRIGGER [old].[trg_Update_Limit_Alarm]
ON [old].[LimitAlarm]
FOR UPDATE
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PrintJobEnhancedTelemetryAlarm]
        SET
            [AlarmEndDateTime] = [i].[EndDateTime],
            [RowLastUpdatedOn] = CAST(SYSUTCDATETIME() AS SMALLDATETIME)
        FROM
            [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [ipjea]
            INNER JOIN
                [Inserted]                             AS [i]
                    ON [ipjea].[AlarmID] = [i].[LimitAlarmID]
        WHERE
            [i].[EndDateTime] IS NOT NULL;
    END;
GO
CREATE TRIGGER [old].[trg_Copy_Limit_Alarm]
ON [old].[LimitAlarm]
FOR INSERT
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[PrintJobEnhancedTelemetryAlarm]
            (
                [AlarmID],
                [PatientID],
                [TopicSessionID],
                [DeviceSessionID],
                [AlarmStartDateTime],
                [AlarmEndDateTime],
                [StrTitleLabel],
                [FirstName],
                [LastName],
                [ID1],
                [ID2],
                [DateOfBirth],
                [FacilityName],
                [UnitName],
                [MonitorName],
                [StrMessage],
                [StrLimitFormat],
                [StrValueFormat],
                [ViolatingValue],
                [SettingViolated],
                [RowLastUpdatedOn]
            )
                    SELECT
                        [i].[LimitAlarmID]                                      AS [AlarmID],
                        [latest].[PatientID],
                        [ts].[TopicSessionID],
                        [ds].[DeviceSessionID],
                        [i].[StartDateTime]                                     AS [AlarmStartTime],
                        [i].[EndDateTime]                                       AS [AlarmEndTime],
                        [ar].[Label]                                            AS [StrTitleLabel],
                        [ipe].[FirstName],
                        [ipe].[LastName],
                        [imm].[MedicalRecordNumberXID]                          AS [ID1],
                        [imm].[MedicalRecordNumberXID2]                         AS [ID2],
                        [ipa].[DateOfBirth]                                     AS [DateOfBirth],
                        [vdsa].[FacilityName]                                   AS [FacilityName],
                        [vdsa].[UnitName]                                       AS [UnitName],
                        COALESCE(RTRIM([vdsa].[MonitorName]), N'---UNKNOWN---') AS [MonitorName], -- Temporary fix to avoid Data Loader error
                        [ar].[StrMessage]                                       AS [StrMessage],
                        [ar].[StrLimitFormat]                                   AS [StrLimitFormat],
                        [ar].[StrValueFormat]                                   AS [StrValueFormat],
                        [i].[ViolatingValue]                                    AS [ViolatingValue],
                        [i].[SettingViolated]                                   AS [SettingViolated],
                        CAST(SYSUTCDATETIME() AS SMALLDATETIME)                 AS [RowLastUpdatedOn]
                    FROM
                        [Inserted]                             AS [i]
                        INNER JOIN
                            [old].[TopicSession]               AS [ts]
                                ON [ts].[TopicSessionID] = [i].[TopicSessionID]
                        INNER JOIN
                            [old].[DeviceSession]              AS [ds]
                                ON [ds].[DeviceSessionID] = [ts].[DeviceSessionID]
                        INNER JOIN
                            (
                                SELECT
                                    [PatientAssignmentSequence].[PatientSessionID],
                                    [PatientAssignmentSequence].[PatientID]
                                FROM
                                    (
                                        SELECT
                                            [psm].[PatientSessionID],
                                            [psm].[PatientID],
                                            ROW_NUMBER() OVER (PARTITION BY
                                                                   [psm].[PatientSessionID]
                                                               ORDER BY
                                                                   [psm].[PatientSessionMapID] DESC
                                                              ) AS [RowNumber]
                                        FROM
                                            [old].[PatientSessionMap] AS [psm]
                                    ) AS [PatientAssignmentSequence]
                                WHERE
                                    [PatientAssignmentSequence].[RowNumber] = 1
                            )                                  AS [latest]
                                ON [latest].[PatientSessionID] = [ts].[PatientSessionID]
                        LEFT OUTER JOIN
                            [Intesys].[MedicalRecordNumberMap] AS [imm]
                                ON [imm].[PatientID] = [latest].[PatientID]
                        LEFT OUTER JOIN
                            [Intesys].[Patient]                AS [ipa]
                                ON [ipa].[PatientID] = [latest].[PatientID]
                        LEFT OUTER JOIN
                            [Intesys].[Person]                 AS [ipe]
                                ON [ipe].[PersonID] = [latest].[PatientID]
                        INNER JOIN
                            [old].[vwDeviceSessionAssignment]  AS [vdsa]
                                ON [vdsa].[DeviceSessionID] = [ds].[DeviceSessionID]
                        INNER JOIN
                            [old].[AlarmResource]              AS [ar]
                                ON [ar].[EnumGroupID] = [i].[EnumGroupID]
                                   AND [ar].[IDEnumValue] = [i].[IDEnumValue]
                                   AND [ar].[Locale] = 'en'
                    WHERE
                        -- SR0006 : Microsoft.Rules.Data : A column in an expression to be compared in a predicate might cause a table scan and degrade performance.
                        -- See article "When the DRY principle doesn't apply : BITWISE operations in SQL Server" abut the fix - http://sqlperformance.com/2012/08/t-sql-queries/dry-principle-bitwise-operations
                        [i].[StatusValue] >= 32
                        AND [i].[StatusValue] & 32 = 32;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains information about limit alarms for patient topic sessions.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'LimitAlarm';

