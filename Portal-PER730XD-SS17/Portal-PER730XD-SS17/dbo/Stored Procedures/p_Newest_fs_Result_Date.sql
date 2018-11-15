CREATE PROCEDURE [dbo].[p_Newest_fs_Result_Date]
    (
     @patient_id UNIQUEIDENTIFIER,
     @fs_id UNIQUEIDENTIFIER = NULL
    )
AS
BEGIN
    SELECT
        MAX([obs_start_dt]) AS [MAX_DATE]
    FROM
        [dbo].[int_flowsheet_detail] AS [ifd]
        INNER JOIN [dbo].[int_result] AS [ir] ON [ifd].[test_cid] = [ifd].[test_cid]
    WHERE
        [ifd].[flowsheet_id] = @fs_id
        AND ([ir].[is_history] = 0
        OR [ir].[is_history] IS NULL
        )
        AND [patient_id] = @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Newest_fs_Result_Date';

