CREATE PROCEDURE [old].[uspGetPatientTwelveLeadReportNew]
    (
        @PatientID INT,
        @ReportID  INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [itlrn].[ReportID],
            [itlrn].[ReportDateTime],
            [itlrn].[VersionNumber],
            [itlrn].[PatientName],
            [itlrn].[IDNumber],
            [itlrn].[BirthDate],
            [itlrn].[Age],
            [itlrn].[Gender],
            [itlrn].[Height],
            [itlrn].[Weight],
            [itlrn].[VentRate],
            [itlrn].[PrInterval],
            [itlrn].[Qt],
            [itlrn].[Qtc],
            [itlrn].[QrsDuration],
            [itlrn].[PAxis],
            [itlrn].[QrsAxis],
            [itlrn].[TAxis],
            [itlrn].[Interpretation],
            [itlrn].[InterpretationEdits],
            [usr].[UserID],
            [usr].[LoginName],
            [itlrn].[SampleRate],
            [itlrn].[SampleCount],
            [itlrn].[NumberOfYPoints],
            [itlrn].[Baseline],
            [itlrn].[YPointsPerUnit],
            [itlrn].[WaveformData],
            [itlrn].[SendRequest],
            [itlrn].[SendComplete],
            [itlrn].[SendDateTime]
        FROM
            [Intesys].[TwelveLeadReportNew] AS [itlrn]
            LEFT OUTER JOIN
                [User].[User]               AS [usr]
                    ON [usr].[UserID] = [itlrn].[UserID]
        WHERE
            [itlrn].[PatientID] = @PatientID
            AND [itlrn].[ReportID] = @ReportID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientTwelveLeadReportNew';

