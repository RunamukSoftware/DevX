CREATE PROCEDURE [dbo].[SaveEventBeatTimeLog]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER,
     @patient_start_ft BIGINT,
     @start_ft BIGINT,
     @num_beats INT,
     @sampleRate SMALLINT,
     @beat_data IMAGE
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_savedevent_beat_time_log]
            ([patient_id],
             [event_id],
             [patient_start_ft],
             [start_ft],
             [num_beats],
             [sample_rate],
             [beat_data]
            )
    VALUES
            (@patient_id,
             @event_id,
             @patient_start_ft,
             @start_ft,
             @num_beats,
             @sampleRate,
             @beat_data
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveEventBeatTimeLog';

