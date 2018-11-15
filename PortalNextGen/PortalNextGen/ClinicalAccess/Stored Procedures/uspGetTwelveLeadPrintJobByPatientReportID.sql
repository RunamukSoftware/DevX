CREATE PROCEDURE [ClinicalAccess].[uspGetTwelveLeadPrintJobByPatientReportID]
    (
        @PatientID INT,
        @ReportID  INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [itlr].[ReportData]
        FROM
            [Intesys].[TwelveLeadReport] AS [itlr]
        WHERE
            [itlr].[PatientID] = @PatientID
            AND [itlr].[ReportID] = @ReportID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetTwelveLeadPrintJobByPatientReportID';

