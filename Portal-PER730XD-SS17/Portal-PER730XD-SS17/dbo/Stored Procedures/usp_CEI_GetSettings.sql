CREATE PROCEDURE [dbo].[usp_CEI_GetSettings]
AS
BEGIN
    SELECT
        [alarm_notification_mode],
        [vitals_update_interval],
        [alarm_polling_interval],
        [port_number],
        [track_alarm_execution],
        [track_vitals_update_execution]
    FROM
        [dbo].[int_event_config];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetSettings';

