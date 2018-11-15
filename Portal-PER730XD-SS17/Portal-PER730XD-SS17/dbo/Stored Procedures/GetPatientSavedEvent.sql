CREATE PROCEDURE [dbo].[GetPatientSavedEvent]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [start_ms],
        [start_dt],
        [center_ft],
        [duration],
        [value1],
        [value2],
        [title],
        [comment],
        [sweep_speed],
        [minutes_per_page],
        [print_format],
        [annotate_data],
        [beat_color],
        [thumbnailChannel]
    FROM
        [dbo].[int_SavedEvent]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id
    ORDER BY
        [insert_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEvent';

