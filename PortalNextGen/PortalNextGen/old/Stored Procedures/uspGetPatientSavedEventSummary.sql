CREATE PROCEDURE [old].[uspGetPatientSavedEventSummary] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ise].[EventID],
            [ise].[StartMilliseconds],
            [ise].[Duration],
            [ise].[StartDateTime],
            [ise].[Title],
            [ise].[Comment],
            [ise].[SweepSpeed],
            [ise].[MinutesPerPage],
            [ise].[ThumbnailChannel]
        FROM
            [Intesys].[PatientSavedEvent] AS [ise]
        WHERE
            [ise].[PatientID] = @PatientID
        ORDER BY
            [ise].[StartDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventSummary';

