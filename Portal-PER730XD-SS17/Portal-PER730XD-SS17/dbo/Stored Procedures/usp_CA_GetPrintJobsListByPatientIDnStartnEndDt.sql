CREATE PROCEDURE [dbo].[usp_CA_GetPrintJobsListByPatientIDnStartnEndDt]
    (
     @patient_id UNIQUEIDENTIFIER,
     @startDt NVARCHAR(MAX) -- TG - Should be DATETIME
    )
AS
BEGIN
    SELECT
        [print_job_id],
        [descr],
        [recording_time],
        [job_net_dt],
        [job_type],
        [page_number]
    FROM
        [dbo].[int_print_job]
    WHERE
        [patient_id] = @patient_id
        AND [job_net_dt] >= CAST(@startDt AS DATETIME)
        AND [page_number] = 1
    UNION
    SELECT
        [print_job_id],
        [descr],
        [recording_time],
        [job_net_dt],
        [job_type],
        [page_number]
    FROM
        [dbo].[int_print_job]
    WHERE
        [patient_id] = @patient_id
        AND [job_net_dt] >= CAST(@startDt AS DATETIME)
        AND [page_number] = (SELECT
                                COUNT(*)
                             FROM
                                [dbo].[int_print_job] AS [print1]
                             WHERE
                                [print1].[print_job_id] = [int_print_job].[print_job_id]
                            )
    ORDER BY
        [job_net_dt] DESC,
        [print_job_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPrintJobsListByPatientIDnStartnEndDt';

