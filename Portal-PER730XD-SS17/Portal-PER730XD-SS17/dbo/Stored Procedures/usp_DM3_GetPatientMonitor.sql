CREATE PROCEDURE [dbo].[usp_DM3_GetPatientMonitor]
    (
     @MonitorID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @PatientGUID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @Connectdate NVARCHAR(50) = NULL -- TG - should be DATETIME
    )
AS
BEGIN
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
        [dbo].[int_patient_monitor]
    WHERE
        [monitor_id] = CAST(@MonitorID AS UNIQUEIDENTIFIER)
        AND [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
        AND [monitor_connect_dt] = CAST(@Connectdate AS DATETIME);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetPatientMonitor';

