CREATE PROCEDURE [dbo].[p_fs_Distrib]
    (
     @patient_id UNIQUEIDENTIFIER,
     @fs_id UNIQUEIDENTIFIER = NULL
    )
AS
BEGIN
    SELECT
        [obs_start_dt],
        COUNT(*) [CNT]
    FROM
        [dbo].[int_flowsheet_detail]
        INNER JOIN [dbo].[int_result] ON [int_flowsheet_detail].[test_cid] = [int_result].[test_cid]
    WHERE
        [flowsheet_id] = @fs_id
        AND ([is_history] = 0
        OR [is_history] IS NULL
        )
        AND [patient_id] = @patient_id
    GROUP BY
        [obs_start_dt]
    ORDER BY
        [obs_start_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_fs_Distrib';

