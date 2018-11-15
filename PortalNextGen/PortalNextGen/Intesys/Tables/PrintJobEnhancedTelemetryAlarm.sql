CREATE TABLE [Intesys].[PrintJobEnhancedTelemetryAlarm] (
    [PrintJobEnhancedTelemetryAlarmID] INT            IDENTITY (1, 1) NOT NULL,
    [AlarmID]                          INT            NOT NULL,
    [PatientID]                        INT            NOT NULL,
    [TopicSessionID]                   INT            NOT NULL,
    [DeviceSessionID]                  INT            NOT NULL,
    [AlarmStartDateTime]               DATETIME2 (7)  NOT NULL,
    [AlarmEndDateTime]                 DATETIME2 (7)  NULL,
    [StrTitleLabel]                    NVARCHAR (250) NOT NULL,
    [FirstName]                        NVARCHAR (50)  NOT NULL,
    [LastName]                         NVARCHAR (50)  NOT NULL,
    [ID1]                              NVARCHAR (30)  NOT NULL,
    [ID2]                              NVARCHAR (30)  NOT NULL,
    [DateOfBirth]                      DATE           NOT NULL,
    [FacilityName]                     NVARCHAR (180) NOT NULL,
    [UnitName]                         NVARCHAR (180) NOT NULL,
    [MonitorName]                      NVARCHAR (255) NOT NULL,
    [StrMessage]                       NVARCHAR (250) NOT NULL,
    [StrLimitFormat]                   NVARCHAR (250) NOT NULL,
    [StrValueFormat]                   NVARCHAR (250) NOT NULL,
    [ViolatingValue]                   NVARCHAR (120) NOT NULL,
    [SettingViolated]                  NVARCHAR (120) NOT NULL,
    [RowLastUpdatedOn]                 SMALLDATETIME  NOT NULL,
    [CreatedDateTime]                  DATETIME2 (7)  CONSTRAINT [DF_PrintJobEnhancedTelemetryAlarm_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintJobEnhancedTelemetryAlarm_PrintJobEnhancedTelemetryAlarmID] PRIMARY KEY CLUSTERED ([PrintJobEnhancedTelemetryAlarmID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryAlarm_DeviceSession_DeviceSessionID] FOREIGN KEY ([DeviceSessionID]) REFERENCES [old].[DeviceSession] ([DeviceSessionID]),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryAlarm_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID]),
    CONSTRAINT [FK_PrintJobEnhancedTelemetryAlarm_TopicSession_TopicSessionID] FOREIGN KEY ([TopicSessionID]) REFERENCES [old].[TopicSession] ([TopicSessionID])
);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_TopicSessionID_INCLUDES]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([TopicSessionID] ASC)
    INCLUDE([AlarmID], [PatientID], [DeviceSessionID], [AlarmStartDateTime], [AlarmEndDateTime], [StrTitleLabel], [FirstName], [LastName], [ID1], [ID2], [DateOfBirth], [FacilityName], [UnitName], [MonitorName], [StrMessage], [StrLimitFormat], [StrValueFormat], [ViolatingValue], [SettingViolated], [RowLastUpdatedOn]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_TopicSessionID_AlarmStartDateTime_AlarmEndDateTime]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([TopicSessionID] ASC, [AlarmStartDateTime] ASC, [AlarmEndDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_PatientID_AlarmStartDateTime_DeviceSessionID_AlarmEndDateTime_INCLUDES]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([PatientID] ASC, [AlarmStartDateTime] ASC)
    INCLUDE([AlarmEndDateTime], [DeviceSessionID], [SettingViolated], [StrLimitFormat], [StrMessage], [StrValueFormat], [ViolatingValue]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_PatientID_AlarmStartTimeUTC_INCLUDES]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([PatientID] ASC, [AlarmStartDateTime] ASC)
    INCLUDE([AlarmID], [AlarmEndDateTime], [StrMessage], [StrLimitFormat], [StrValueFormat], [ViolatingValue], [SettingViolated]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_AlarmEndTimeUTC_RowLastUpdatedOn_AlarmID]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([AlarmEndDateTime] ASC, [RowLastUpdatedOn] ASC)
    INCLUDE([AlarmID]) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_DeviceSessionID_AlarmStartDateTime_AlarmEndDateTime]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([DeviceSessionID] ASC, [AlarmStartDateTime] ASC, [AlarmEndDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_PrintJobEnhancedTelemetryAlarm_DeviceSessionId_AlarmStartTimeUTC_AlarmEndTimeUTC_PatientID]
    ON [Intesys].[PrintJobEnhancedTelemetryAlarm]([DeviceSessionID] ASC, [AlarmStartDateTime] ASC, [AlarmEndDateTime] ASC)
    INCLUDE([PatientID]) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PrintJobEnhancedTelemetryAlarm';

