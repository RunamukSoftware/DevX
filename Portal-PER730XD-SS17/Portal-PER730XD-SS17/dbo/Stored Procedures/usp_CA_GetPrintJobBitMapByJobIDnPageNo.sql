CREATE PROCEDURE [dbo].[usp_CA_GetPrintJobBitMapByJobIDnPageNo]
    (
     @print_job_id UNIQUEIDENTIFIER,
     @page_number INT
    )
AS
BEGIN
    SELECT
        [byte_height],
        [bitmap_height],
        [bitmap_width],
        [print_bitmap],
        [recording_time]
    FROM
        [dbo].[int_print_job]
    WHERE
        [print_job_id] = @print_job_id
        AND [page_number] = @page_number;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPrintJobBitMapByJobIDnPageNo';

