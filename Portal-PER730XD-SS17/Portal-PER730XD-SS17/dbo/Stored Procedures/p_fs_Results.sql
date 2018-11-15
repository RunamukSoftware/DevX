CREATE PROCEDURE [dbo].[p_fs_Results]
    (
     @patient_id UNIQUEIDENTIFIER,
     @min_date DATETIME,
     @max_date DATETIME,
     @fs_id UNIQUEIDENTIFIER = NULL
    )
AS
BEGIN
    SELECT DISTINCT 
        --[name],
        [int_result].[test_cid],
        [obs_start_dt],
        [result_value],
        [result_id],
        [has_history],
        [order_id],
        [flowsheet_detail_id],
        [mod_user_id]
    FROM
        [dbo].[int_flowsheet_detail]
        INNER JOIN [dbo].[int_result] ON [int_flowsheet_detail].[test_cid] = [int_result].[test_cid]
    WHERE
        [flowsheet_id] = @fs_id
        AND ([is_history] = 0
        OR [is_history] IS NULL
        )
        AND [patient_id] = @patient_id
        AND [obs_start_dt] >= @min_date
        AND [obs_start_dt] <= @max_date;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_fs_Results';

