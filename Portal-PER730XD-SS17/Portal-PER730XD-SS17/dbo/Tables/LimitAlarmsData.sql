CREATE TABLE [dbo].[LimitAlarmsData] (
    [AlarmId]             UNIQUEIDENTIFIER                                   NOT NULL,
    [SettingViolated]     VARCHAR (25)                                       NOT NULL,
    [ViolatingValue]      VARCHAR (25)                                       NOT NULL,
    [StartDateTime]       DATETIME                                           NOT NULL,
    [EndDateTime]         DATETIME                                           NULL,
    [StatusValue]         INT                                                NOT NULL,
    [DetectionTimestamp]  DATETIME                                           NULL,
    [Acknowledged]        BIT                                                NOT NULL,
    [PriorityWeightValue] INT                                                NOT NULL,
    [AcquiredDateTimeUTC] DATETIME                                           NOT NULL,
    [Leads]               INT                                                NOT NULL,
    [WaveformFeedTypeId]  UNIQUEIDENTIFIER                                   NOT NULL,
    [TopicSessionId]      UNIQUEIDENTIFIER                                   NOT NULL,
    [FeedTypeId]          UNIQUEIDENTIFIER                                   NOT NULL,
    [IDEnumValue]         INT                                                NOT NULL,
    [EnumGroupId]         UNIQUEIDENTIFIER                                   NOT NULL,
    [Sequence]            BIGINT                                             IDENTITY (-9223372036854775808, 1) NOT FOR REPLICATION NOT NULL,
    [CreatedDateTime]     DATETIME2 (7)                                      CONSTRAINT [DF_LimitAlarmsData_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [SysStartTime]        DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT [DF_LimitAlarmsData_SysStartTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [SysEndTime]          DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   CONSTRAINT [DF_LimitAlarmsData_SysEndTime] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.99999999')) NOT NULL,
    CONSTRAINT [PK_LimitAlarmsData_Sequence] PRIMARY KEY CLUSTERED ([Sequence] ASC) WITH (FILLFACTOR = 100),
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo].[LimitAlarmsData_TemporalHistory], DATA_CONSISTENCY_CHECK=ON, HISTORY_RETENTION_PERIOD=1 WEEK));






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LimitAlarmsData_AlarmId_Sequence]
    ON [dbo].[LimitAlarmsData]([AlarmId] ASC, [Sequence] ASC) WITH (FILLFACTOR = 100);
GO
CREATE NONCLUSTERED INDEX [ix_LimitAlarmsData_TopicSessionId_StartDateTime_includes]
    ON [dbo].[LimitAlarmsData]([TopicSessionId] ASC, [StartDateTime] ASC)
    INCLUDE([SettingViolated], [ViolatingValue], [EndDateTime], [PriorityWeightValue], [WaveformFeedTypeId], [IDEnumValue], [EnumGroupId]) WITH (FILLFACTOR = 100);
GO
CREATE TRIGGER [dbo].[trg_Copy_Limit_Alarm]
ON [dbo].[LimitAlarmsData]
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[int_print_job_et_alarm] AS [Destination]
    USING (SELECT
               [i].[AlarmId] AS [AlarmId],
               [LatestPatientAssignment].[PatientId] AS [PatientId],
               [ts].[Id] AS [TopicSessionId],
               [ds].[Id] AS [DeviceSessionId],
               [i].[StartDateTime] AS [AlarmStartTimeUTC],
               [i].[EndDateTime] AS [AlarmEndTimeUTC],
               [ar].[Label] AS [StrTitleLabel],
               [iper].[first_nm] AS [FirstName],
               [iper].[last_nm] AS [LastName],
               ISNULL([iper].[last_nm], N'') + N', ' + ISNULL([iper].[first_nm], N'') AS [FullName],
               [imm].[mrn_xid] AS [ID1],
               [imm].[mrn_xid2] AS [ID2],
               [ipat].[dob] AS [DOB],
               [vdsa].[FacilityName] AS [FacilityName],
               [vdsa].[UnitName] AS [UnitName],
               [vdsa].[MonitorName] AS [MonitorName],
               [ar].[StrMessage] AS [StrMessage],
               [ar].[StrLimitFormat] AS [StrLimitFormat],
               [ar].[StrValueFormat] AS [StrValueFormat],
               [i].[ViolatingValue] AS [ViolatingValue],
               [i].[SettingViolated] AS [SettingViolated]
           FROM [Inserted] AS [i]
               INNER JOIN [dbo].[TopicSessions] AS [ts]
                   ON [ts].[Id] = [i].[TopicSessionId]
               INNER JOIN [dbo].[DeviceSessions] AS [ds]
                   ON [ds].[Id] = [ts].[DeviceSessionId]
               INNER JOIN (SELECT
                               [PatientAssignmentSequence].[PatientSessionId],
                               [PatientAssignmentSequence].[PatientId]
                           FROM (SELECT
                                     [psm].[PatientSessionId],
                                     [psm].[PatientId],
                                     ROW_NUMBER() OVER (PARTITION BY [psm].[PatientSessionId]
                                                        ORDER BY [psm].[Sequence] DESC) AS [RowNumber]
                                 FROM [dbo].[PatientSessionsMap] AS [psm]) AS [PatientAssignmentSequence]
                           WHERE [PatientAssignmentSequence].[RowNumber] = 1) AS [LatestPatientAssignment]
                   ON [LatestPatientAssignment].[PatientSessionId] = [ts].[PatientSessionId]
               LEFT OUTER JOIN [dbo].[int_mrn_map] AS [imm]
                   ON [imm].[patient_id] = [LatestPatientAssignment].[PatientId]
                      AND [imm].[merge_cd] = 'C'
               LEFT OUTER JOIN [dbo].[int_patient] AS [ipat]
                   ON [ipat].[patient_id] = [LatestPatientAssignment].[PatientId]
               LEFT OUTER JOIN [dbo].[int_person] AS [iper]
                   ON [iper].[person_id] = [LatestPatientAssignment].[PatientId]
               INNER JOIN [dbo].[v_DeviceSessionAssignment] AS [vdsa]
                   ON [vdsa].[DeviceSessionId] = [ds].[Id]
               INNER JOIN [dbo].[AlarmResources] AS [ar]
                   ON [ar].[EnumGroupId] = [i].[EnumGroupId]
                      AND [ar].[IDEnumValue] = [i].[IDEnumValue]
                      AND [ar].[Locale] = 'en'
           WHERE
               -- SR0006 : Microsoft.Rules.Data : A column in an expression to be compared in a predicate might cause a table scan and degrade performance.
               -- See article "When the DRY principle doesn't apply : BITWISE operations in SQL Server" abut the fix - http://sqlperformance.com/2012/08/t-sql-queries/dry-principle-bitwise-operations
               [i].[StatusValue] >= 32
               AND [i].[StatusValue] & 32 = 32) AS [Source]
    ON [Source].[AlarmId] = [Destination].[AlarmId]
    WHEN NOT MATCHED BY TARGET
        THEN INSERT ([AlarmId],
                     [PatientId],
                     [TopicSessionId],
                     [DeviceSessionId],
                     [AlarmStartTimeUTC],
                     [AlarmEndTimeUTC],
                     [StrTitleLabel],
                     [FirstName],
                     [LastName],
                     [FullName],
                     [ID1],
                     [ID2],
                     [DOB],
                     [FacilityName],
                     [UnitName],
                     [MonitorName],
                     [StrMessage],
                     [StrLimitFormat],
                     [StrValueFormat],
                     [ViolatingValue],
                     [SettingViolated],
                     [RowLastUpdatedOn])
             VALUES (
                    [Source].[AlarmId], [Source].[PatientId], [Source].[TopicSessionId], [Source].[DeviceSessionId],
                    [Source].[AlarmStartTimeUTC], [Source].[AlarmEndTimeUTC], [Source].[StrTitleLabel],
                    [Source].[FirstName], [Source].[LastName], [Source].[FullName], [Source].[ID1], [Source].[ID2],
                    [Source].[DOB], [Source].[FacilityName], [Source].[UnitName], [Source].[MonitorName],
                    [Source].[StrMessage], [Source].[StrLimitFormat], [Source].[StrValueFormat],
                    [Source].[ViolatingValue], [Source].[SettingViolated], CAST(GETDATE() AS SMALLDATETIME)
                    )
    WHEN MATCHED
        THEN UPDATE SET
                 [Destination].[AlarmEndTimeUTC] = [Source].[AlarmEndTimeUTC],
                 [Destination].[RowLastUpdatedOn] = CAST(GETDATE() AS SMALLDATETIME);
END;
GO

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains information about limit alarms for patient topic sessions.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'LimitAlarmsData';

GO
CREATE NONCLUSTERED INDEX [IX_LimitAlarmsData_StartDateTime]
    ON [dbo].[LimitAlarmsData]([StartDateTime] DESC) WITH (FILLFACTOR = 100);

