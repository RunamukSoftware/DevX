CREATE PROCEDURE [old].[uspRetrieveBeatTimeLog]
    (
        @UserID    INT,
        @PatientID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ibtl].[UserID],
            [ibtl].[StartDateTime],
            [ibtl].[NumberBeats],
            [ibtl].[SampleRate],
            [ibtl].[BeatData]
        FROM
            [Intesys].[BeatTimeLog] AS [ibtl]
        WHERE
            [ibtl].[UserID] = @UserID
            AND [ibtl].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveBeatTimeLog';

