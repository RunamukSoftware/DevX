CREATE PROCEDURE [dbo].[GetSavedEventBeatTimeLog]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [patient_start_ft] AS [PATIENT_FT],
        [start_ft] AS [start_ft],
        [num_beats] AS [NUM_BEATS],
        [sample_rate] AS [SAMPLE_RATE],
        [beat_data] AS [BEAT_DATA]
    FROM
        [dbo].[int_savedevent_beat_time_log]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetSavedEventBeatTimeLog';

