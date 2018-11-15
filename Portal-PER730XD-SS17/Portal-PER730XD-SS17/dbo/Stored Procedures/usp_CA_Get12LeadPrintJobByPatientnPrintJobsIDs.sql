CREATE PROCEDURE [dbo].[usp_CA_Get12LeadPrintJobByPatientnPrintJobsIDs]
    (
     @patient_id UNIQUEIDENTIFIER,
     @print_job_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [twelve_lead_data]
    FROM
        [dbo].[int_print_job]
    WHERE
        [patient_id] = @patient_id
        AND [print_job_id] = @print_job_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_Get12LeadPrintJobByPatientnPrintJobsIDs';

