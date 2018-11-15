CREATE VIEW [old].[vwLegacyPatientMonitorCombined]
WITH SCHEMABINDING
AS
    SELECT
        [vlpm].[PatientID]           AS [PatientMonitorID],
        [vlpm].[PatientID]           AS [PatientID],
        NULL                         AS [OriginalPatientID],
        [vlpm].[DeviceID]            AS [MonitorID],
        '1'                          AS [MonitorInterval],
        'P'                          AS [poll_type],
        [vlpm].[SessionStartTime] AS [monitor_connectDateTime],
        NULL                         AS [monitor_connect_num],
        NULL                         AS [disableSwitch],
        SYSUTCDATETIME()             AS [LastPollingDateTime],
        SYSUTCDATETIME()             AS [LastResultDateTime],
        SYSUTCDATETIME()             AS [LastEpisodicDateTime],
        NULL                         AS [PollStartDateTime],
        NULL                         AS [PollEndDateTime],
        NULL                         AS [LastOutboundDateTime],
        NULL                         AS [MonitorStatus],
        NULL                         AS [monitor_error],
        [vlpm].[EncounterID],
        NULL                         AS [live_untilDateTime],
        '1'                          AS [ActiveSwitch]
    FROM
        [old].[vwLegacyPatientMonitor] AS [vlpm]
    UNION ALL
    SELECT
        [ipm].[PatientMonitorID],
        [ipm].[PatientID],
        [ipm].[OriginalPatientID],
        [ipm].[MonitorID],
        [ipm].[MonitorInterval],
        [ipm].[PollingType],
        [ipm].[MonitorConnectDateTime],
        [ipm].[MonitorConnectNumber],
        [ipm].[DisableSwitch],
        [ipm].[LastPollingDateTime],
        [ipm].[LastResultDateTime],
        [ipm].[LastEpisodicDateTime],
        [ipm].[PollStartDateTime],
        [ipm].[PollEndDateTime],
        [ipm].[LastOutboundDateTime],
        [ipm].[MonitorStatus],
        [ipm].[MonitorError],
        [ipm].[EncounterID],
        [ipm].[LiveUntilDateTime],
        [ipm].[ActiveSwitch]
    FROM
        [Intesys].[PatientMonitor] AS [ipm];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyPatientMonitorCombined';

