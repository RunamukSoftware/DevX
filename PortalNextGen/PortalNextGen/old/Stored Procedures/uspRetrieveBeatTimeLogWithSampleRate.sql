CREATE PROCEDURE [old].[uspRetrieveBeatTimeLogWithSampleRate]
    (
        @UserID     INT,
        @PatientID  INT,
        @SampleRate SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [btl].[UserID],
            [btl].[PatientID],
            [btl].[StartDateTime],
            [btl].[NumberBeats],
            [btl].[SampleRate],
            [btl].[BeatData]
        FROM
            [Intesys].[BeatTimeLog] AS [btl]
        WHERE
            [btl].[UserID] = @UserID
            AND [btl].[PatientID] = @PatientID
            AND [btl].[SampleRate] = @SampleRate;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveBeatTimeLogWithSampleRate';

