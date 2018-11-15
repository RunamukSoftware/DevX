CREATE PROCEDURE [dbo].[GetPatientSavedEventMonitorLog]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @event_id AS UNIQUEIDENTIFIER,
     @timetag_type AS INT
    )
AS
BEGIN
    SELECT
        [monitor_event_type] AS [EVENTTYPE],
        [start_ms] AS [STARTMS],
        [end_ms] AS [ENDMS]
    FROM
        [dbo].[int_savedevent_event_log]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id
        AND [timetag_type] = @timetag_type;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventMonitorLog';

