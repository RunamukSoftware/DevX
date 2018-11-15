CREATE PROCEDURE [dbo].[usp_CA_Get12LeadPrintJobByPatientnReportIDs]
    (
     @patient_id UNIQUEIDENTIFIER,
     @report_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [report_data]
    FROM
        [dbo].[int_12lead_report]
    WHERE
        [patient_id] = @patient_id
        AND [report_id] = @report_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_Get12LeadPrintJobByPatientnReportIDs';

