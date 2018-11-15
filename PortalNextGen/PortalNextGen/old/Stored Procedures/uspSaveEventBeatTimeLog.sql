CREATE PROCEDURE [old].[uspSaveEventBeatTimeLog]
    (
        @PatientID            INT,
        @EventID              INT,
        @PatientStartDateTime DATETIME2(7),
        @StartDateTime        DATETIME2(7),
        @num_beats            INT,
        @sampleRate           SMALLINT,
        @beat_data            VARBINARY(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventBeatTimeLog]
            (
                [PatientID],
                [EventID],
                [PatientStartDateTime],
                [StartDateTime],
                [NumberOfBeats],
                [SampleRate],
                [BeatData]
            )
        VALUES
            (
                @PatientID, @EventID, @PatientStartDateTime, @StartDateTime, @num_beats, @sampleRate, @beat_data
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventBeatTimeLog';

