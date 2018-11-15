CREATE PROCEDURE [dbo].[GetPatientSavedEventSummary]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [event_id] AS [ID],
        [start_ms],
        [duration],
        [start_dt],
        [title],
        [comment],
        [sweep_speed],
        [minutes_per_page],
        [thumbnailChannel]
    FROM
        [dbo].[int_SavedEvent]
    WHERE
        [patient_id] = @patient_id
    ORDER BY
        [start_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventSummary';

