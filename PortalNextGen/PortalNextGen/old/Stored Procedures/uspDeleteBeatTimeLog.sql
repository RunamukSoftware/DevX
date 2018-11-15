CREATE PROCEDURE [old].[uspDeleteBeatTimeLog]
    (
        @UserID     INT,
        @PatientID  INT,
        @SampleRate SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ibtl]
        FROM
            [Intesys].[BeatTimeLog] AS [ibtl]
        WHERE
            [ibtl].[UserID] = @UserID
            AND [ibtl].[PatientID] = @PatientID
            AND [ibtl].[SampleRate] = @SampleRate;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteBeatTimeLog';

