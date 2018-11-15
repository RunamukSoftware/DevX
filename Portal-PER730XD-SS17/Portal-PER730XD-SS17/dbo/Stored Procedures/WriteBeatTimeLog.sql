CREATE PROCEDURE [dbo].[WriteBeatTimeLog]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @StartFt BIGINT,
     @NumBeats INT,
     @BeatData IMAGE,
     @SampleRate SMALLINT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_beat_time_log]
            ([user_id],
             [patient_id],
             [start_ft],
             [num_beats],
             [beat_data],
             [sample_rate]
            )
    VALUES
            (CAST(@UserID AS UNIQUEIDENTIFIER),
             CAST(@PatientId AS UNIQUEIDENTIFIER),
             @StartFt,
             @NumBeats,
             @BeatData,
             @SampleRate
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WriteBeatTimeLog';

