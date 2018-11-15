CREATE PROCEDURE [old].[uspGetSavedEventBeatTimeLog]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isbtl].[PatientStartDateTime] AS [PATIENTDateTime],
            [isbtl].[StartDateTime]        AS [StartDateTime],
            [isbtl].[NumberOfBeats]        AS [NUM_BEATS],
            [isbtl].[SampleRate]           AS [SampleRate],
            [isbtl].[BeatData]             AS [BEATData]
        FROM
            [Intesys].[SavedEventBeatTimeLog] AS [isbtl]
        WHERE
            [isbtl].[PatientID] = @PatientID
            AND [isbtl].[EventID] = @EventID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSavedEventBeatTimeLog';

