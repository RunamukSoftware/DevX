CREATE VIEW [dbo].[v_LegacyPatientMonitorCombined]
WITH
     SCHEMABINDING
AS
SELECT
    [PatientId] AS [patient_monitor_id],
    [PatientId] AS [patient_id],
    NULL AS [orig_patient_id],
    [DeviceId] AS [monitor_id],
    '1' AS [monitor_interval],
    'P' AS [poll_type],
    [SessionStartTimeUTC] AS [monitor_connect_dt],
    NULL AS [monitor_connect_num],
    NULL AS [disable_sw],
    GETDATE() AS [last_poll_dt],
    GETDATE() AS [last_result_dt],
    GETDATE() AS [last_episodic_dt],
    NULL AS [poll_start_dt],
    NULL AS [poll_end_dt],
    NULL AS [last_outbound_dt],
    NULL AS [monitor_status],
    NULL AS [monitor_error],
    [EncounterId] AS [encounter_id],
    NULL AS [live_until_dt],
    '1' AS [active_sw]
FROM
    [dbo].[v_LegacyPatientMonitor]
UNION ALL
SELECT
    [patient_monitor_id],
    [patient_id],
    [orig_patient_id],
    [monitor_id],
    [monitor_interval],
    [poll_type],
    [monitor_connect_dt],
    [monitor_connect_num],
    [disable_sw],
    [last_poll_dt],
    [last_result_dt],
    [last_episodic_dt],
    [poll_start_dt],
    [poll_end_dt],
    [last_outbound_dt],
    [monitor_status],
    [monitor_error],
    [encounter_id],
    [live_until_dt],
    [active_sw]
FROM
    [dbo].[int_patient_monitor];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyPatientMonitorCombined';

