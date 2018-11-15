CREATE PROCEDURE [old].[uspGetPatientTwelveLeadReports] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [itlr].[ReportID],
            [itlr].[ReportDateTime]
        FROM
            [Intesys].[TwelveLeadReport] AS [itlr]
        WHERE
            [itlr].[PatientID] = @PatientID
        ORDER BY
            [itlr].[ReportDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientTwelveLeadReports';

