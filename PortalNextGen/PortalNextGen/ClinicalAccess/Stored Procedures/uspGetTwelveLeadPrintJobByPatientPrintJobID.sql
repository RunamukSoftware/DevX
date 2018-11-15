CREATE PROCEDURE [ClinicalAccess].[uspGetTwelveLeadPrintJobByPatientPrintJobID]
    (
        @PatientID  INT,
        @PrintJobID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [pj].[TwelveLeadData]
        FROM
            [Intesys].[PrintJob] AS [pj]
        WHERE
            [pj].[PatientID] = @PatientID
            AND [pj].[PrintJobID] = @PrintJobID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetTwelveLeadPrintJobByPatientPrintJobID';

