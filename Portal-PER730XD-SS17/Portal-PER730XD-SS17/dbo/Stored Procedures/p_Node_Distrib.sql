CREATE PROCEDURE [dbo].[p_Node_Distrib]
    (
     @patient_id UNIQUEIDENTIFIER,
     @node_id INT = NULL
    )
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @level INT = 0;

    CREATE TABLE [#TMP_NODES]
        (
         [node_id] INT,
         [rank] INT NULL,
         [parent_node_id] INT NULL,
         [node_name] VARCHAR(100) NULL,
         [level] INT
        );

    IF (@node_id IS NULL)
    BEGIN
        INSERT  INTO [#TMP_NODES]
        SELECT
            [node_id],
            [rank],
            [parent_node_id],
            CAST([node_name] AS VARCHAR(100)),
            @level [LEVEL]
        FROM
            [dbo].[int_test_group]
        WHERE
            [parent_node_id] IS NULL;
    END;
    ELSE
    BEGIN
        INSERT  INTO [#TMP_NODES]
        SELECT
            [node_id],
            [rank],
            [parent_node_id],
            CAST([node_name] AS VARCHAR(100)),
            @level [LEVEL]
        FROM
            [dbo].[int_test_group]
        WHERE
            [node_id] = @node_id;
    END;

    WHILE (@@ROWCOUNT <> 0)
    BEGIN
        SET @level = @level + 1;

        INSERT  INTO [#TMP_NODES]
        SELECT
            [node_id],
            [rank],
            [parent_node_id],
            CAST([node_name] AS VARCHAR(100)),
            @level
        FROM
            [dbo].[int_test_group]
        WHERE
            [parent_node_id] IN (SELECT
                                    [node_id]
                                 FROM
                                    [#TMP_NODES])
            AND [node_id] NOT IN (SELECT
                                    [node_id]
                                  FROM
                                    [#TMP_NODES]);
    END;

    SELECT
        [tn].[rank] AS [NODERANK],
        [tn].[node_id],
        [tn].[node_name],
        [itgd].[rank] AS [DETRANK],
        [itgd].[nm],
        [itgd].[display_type],
        'rtTest' AS [TEST_TYPE],
        [ir].[obs_start_dt],
        [ir].[order_id],
        [ir].[univ_svc_cid],
        [ir].[test_cid],
        [ir].[history_seq],
        [ir].[test_sub_id],
        [ir].[order_line_seq_no],
        [ir].[test_result_seq_no],
        [ir].[result_dt],
        [ir].[value_type_cd],
        [ir].[specimen_id],
        [ir].[source_cid],
        [ir].[status_cid],
        [ir].[result_units_cid],
        [ir].[reference_range_id],
        [ir].[abnormal_cd],
        [ir].[nsurv_tfr_ind],
        [ir].[result_value]
    INTO
        [#TMP_RESULTS]
    FROM
        [#TMP_NODES] AS [tn]
        INNER JOIN [dbo].[int_test_group_detail] AS [itgd] ON [tn].[node_id] = [itgd].[node_id]
        INNER JOIN [dbo].[int_result] AS [ir] ON [itgd].[test_cid] = [ir].[test_cid]
    WHERE
        [ir].[patient_id] = @patient_id
        AND ([ir].[is_history] IS NULL
        OR [ir].[is_history] = 0
        )
    UNION
    SELECT DISTINCT
        [tn].[rank] AS [NODERANK],
        [tn].[node_id],
        [tn].[node_name],
        [itgd].[rank] AS [DETRANK],
        [itgd].[nm],
        [itgd].[display_type],
        'rtUsid' AS [TEST_TYPE],
        [ir].[obs_start_dt],
        [ir].[order_id],
        [ir].[univ_svc_cid],
        NULL [TEST_CID],
        [ir].[history_seq],
        NULL [TEST_SUB_ID],
        [ir].[order_line_seq_no],
        NULL [TEST_RESULT_SEQ_NO],
        [ir].[result_dt],
        NULL [VALUE_TYPE_CD],
        [ir].[specimen_id],
        [ir].[source_cid],
        NULL [STATUS_CID],
        NULL [RESULT_UNITS_CID],
        NULL [REFERENCE_RANGE_ID],
        [ir].[abnormal_cd],
        [ir].[nsurv_tfr_ind],
        NULL [RESULT_VALUE]
    FROM
        [#TMP_NODES] AS [tn]
        INNER JOIN [dbo].[int_test_group_detail] AS [itgd] ON [tn].[node_id] = [itgd].[node_id]
        INNER JOIN [dbo].[int_result] AS [ir] ON [itgd].[univ_svc_cid] = [ir].[univ_svc_cid]
    WHERE
        ([ir].[is_history] IS NULL
        OR [ir].[is_history] = 0
        )
        AND [ir].[patient_id] = @patient_id;

    SELECT
        [obs_start_dt],
        COUNT(*) [CNT]
    FROM
        [#TMP_RESULTS]
    GROUP BY
        [obs_start_dt]
    ORDER BY
        [obs_start_dt] DESC;

    /*
    SELECT
        univ_svc_cid,
        test_cid
    INTO
        #tmp_details
    FROM
        dbo.cdr_test_group_detail,
        #tmp_nodes
    WHERE
        cdr_test_group_detail.node_id = #tmp_nodes.node_id

    SELECT
        obs_start_dt,
        test_cid,
        univ_svc_cid,
        count(*) cnt
    INTO
        #tmp_results
    FROM
        dbo.int_result
    WHERE
        patient_id = @patient_id
        AND is_history IS NULL
    GROUP BY
        obs_start_dt,
        test_cid,
        univ_svc_cid
  
    SELECT
        obs_start_dt,
        cnt
    INTO
        #tmp_answer
    FROM
        #tmp_results,
        #tmp_details
    WHERE
        #tmp_results.test_cid = #tmp_details.test_cid
    UNION ALL
    SELECT
        obs_start_dt,
        cnt
    FROM
        #tmp_results,
        #tmp_details
    WHERE
        #tmp_results.univ_svc_cid = #tmp_details.univ_svc_cid

    SELECT
        obs_start_dt,
        sum(cnt) cnt
    FROM
        #tmp_answer
    GROUP BY
        obs_start_dt
    ORDER BY
        obs_start_dt DESC
  
    DROP TABLE #tmp_details
    */

    DROP TABLE [#TMP_NODES];

    DROP TABLE [#TMP_RESULTS];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Node_Distrib';

