CREATE PROCEDURE [dbo].[usp_GetPrintJobList]
    (
     @filters NVARCHAR(MAX),
     @FromDate NVARCHAR(MAX),
     @ToDate NVARCHAR(MAX)
    )
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX)= N'
        SELECT 
            int_print_job.print_sw AS [Print], 
            int_print_job.printer_name AS [Printer],
            int_print_job.descr AS [Description],
            int_print_job.page_number AS [Pages],
            int_print_job.row_dt AS [Date],
            int_mrn_map.mrn_xid as [Patient],
            int_print_job.status_code AS [Status],
            int_print_job.status_msg AS [Message],
            int_print_job.job_type,
            int_mrn_map.patient_id  
        FROM 
            dbo.int_print_job 
                INNER JOIN dbo.int_mrn_map 
                    ON int_print_job.patient_id = int_mrn_map.patient_id 
        WHERE int_print_job.job_net_dt BETWEEN ';
                    
    SET @Query += N'''' + @FromDate + N'''';
    SET @Query += N' AND ';
    SET @Query += N'''' + @ToDate + N'''';
                                                    
    IF (LEN(@filters) > 0)
        SET @Query += N' AND ';

    SET @Query += @filters;
                                                            
    EXEC(@Query);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetPrintJobList';

