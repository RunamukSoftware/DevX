CREATE PROCEDURE [old].[uspGetPatientSavedEvent]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ise].[StartMilliseconds],
            [ise].[StartDateTime],
            [ise].[CenterDateTime],
            [ise].[Duration],
            [ise].[Value1],
            [ise].[Value2],
            [ise].[Title],
            [ise].[Comment],
            [ise].[SweepSpeed],
            [ise].[MinutesPerPage],
            [ise].[PrintFormat],
            [ise].[AnnotateData],
            [ise].[BeatColor],
            [ise].[ThumbnailChannel]
        FROM
            [Intesys].[PatientSavedEvent] AS [ise]
        WHERE
            [ise].[PatientID] = @PatientID
            AND [ise].[EventID] = @EventID
        ORDER BY
            [ise].[InsertDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEvent';

