CREATE PROCEDURE [dbo].[GetPatientSavedEventCalipers]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [channel_type],
        [caliper_type],
        [calipers_orientation],
        [caliper_text],
        [caliper_start_ms],
        [caliper_end_ms],
        [caliper_top],
        [caliper_bottom]
    FROM
        [dbo].[int_savedevent_calipers]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventCalipers';

