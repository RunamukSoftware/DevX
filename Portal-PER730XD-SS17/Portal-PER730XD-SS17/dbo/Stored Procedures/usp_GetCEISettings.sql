CREATE PROCEDURE [dbo].[usp_GetCEISettings]
AS
BEGIN
    SELECT
        [track_alarm_execution],
        [track_vitals_update_execution],
        [alarm_notification_mode],
        [vitals_update_interval],
        [port_number]
    FROM
        [dbo].[int_event_config];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetCEISettings';

