CREATE PROCEDURE [dbo].[GetPatientTwelveLeadReports]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [report_id],
        [report_dt]
    FROM
        [dbo].[int_12lead_report]
    WHERE
        [patient_id] = @patient_id
    ORDER BY
        [report_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientTwelveLeadReports';

