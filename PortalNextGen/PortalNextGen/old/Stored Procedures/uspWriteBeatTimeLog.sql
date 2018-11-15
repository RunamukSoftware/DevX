CREATE PROCEDURE [old].[uspWriteBeatTimeLog]
    (
        @UserID        INT,
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @NumBeats      INT,
        @BeatData      VARBINARY(MAX),
        @SampleRate    SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[BeatTimeLog]
            (
                [UserID],
                [PatientID],
                [StartDateTime],
                [NumberBeats],
                [BeatData],
                [SampleRate]
            )
        VALUES
            (
                @UserID, @PatientID, @StartDateTime, @NumBeats, @BeatData, @SampleRate
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteBeatTimeLog';

