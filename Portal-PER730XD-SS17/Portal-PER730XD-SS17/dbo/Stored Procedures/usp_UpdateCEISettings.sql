CREATE PROCEDURE [dbo].[usp_UpdateCEISettings]
    (
     @alarmNotificationMode INT = NULL,
     @vitalsUpdateInterval INT = NULL,
     @portNumber INT = NULL,
     @trackAlarmExecution TINYINT = NULL,
     @trackVitalsUpdateExecution TINYINT = NULL
    )
AS
BEGIN
    UPDATE
        [dbo].[int_event_config]
    SET
        [alarm_notification_mode] = ISNULL(@alarmNotificationMode, [alarm_notification_mode]),
        [vitals_update_interval] = ISNULL(@vitalsUpdateInterval, [vitals_update_interval]),
        [port_number] = ISNULL(@portNumber, [port_number]),
        [track_alarm_execution] = ISNULL(@trackAlarmExecution, [track_alarm_execution]),
        [track_vitals_update_execution] = ISNULL(@trackVitalsUpdateExecution, [track_vitals_update_execution]);

END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateCEISettings';

