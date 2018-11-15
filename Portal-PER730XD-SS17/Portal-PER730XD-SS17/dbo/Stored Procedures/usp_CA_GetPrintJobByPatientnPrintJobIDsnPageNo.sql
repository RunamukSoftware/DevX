CREATE PROCEDURE [dbo].[usp_CA_GetPrintJobByPatientnPrintJobIDsnPageNo]
    (
     @patient_id UNIQUEIDENTIFIER,
     @print_job_id UNIQUEIDENTIFIER,
     @page_number INT
    )
AS
BEGIN
    SELECT
        [descr],
        [sweep_speed],
        [duration],
        [num_channels],
        [recording_time],
        [job_net_dt],
        [job_type],
        [page_number],
        [annotation1],
        [annotation2],
        [annotation3],
        [annotation4]
    FROM
        [dbo].[int_print_job]
    WHERE
        [patient_id] = @patient_id
        AND [print_job_id] = @print_job_id
        AND [page_number] = @page_number

/* This will need to be added back when UVSL print job are handled by DataLoader

    UNION ALL

    SELECT 
        [descr], 
        [sweep_speed],
        [duration], 
        [num_channels], 
        [recording_time], 
        [job_net_dt], 
        [job_type], 
        [page_number], 
        [annotation1], 
        [annotation2], 
        [annotation3], 
        [annotation4]
    FROM 
        [dbo].[v_PrintJobs]
    WHERE 
        [patient_id] = @patient_id 
        AND [print_job_id] = @print_job_id 
        AND [page_number] = @page_number
*/
    ORDER BY
        [job_net_dt];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPrintJobByPatientnPrintJobIDsnPageNo';

