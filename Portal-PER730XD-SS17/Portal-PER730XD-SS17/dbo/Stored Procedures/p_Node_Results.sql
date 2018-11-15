CREATE PROCEDURE [dbo].[p_Node_Results]
    (
     @patient_id UNIQUEIDENTIFIER,
     @min_date DATETIME,
     @max_date DATETIME,
     @node_id INT = NULL
    )
AS
BEGIN
    DECLARE @level INT = 0;

    CREATE TABLE [#TMP_NODES]
        (
         [node_id] INT,
         [rank] INT NULL,
         [parent_node_id] INT NULL,
         [node_name] NVARCHAR(100) NULL,
         [level] INT
        );

    IF (@node_id IS NULL)
    BEGIN
        INSERT  INTO [#TMP_NODES]
        SELECT
            [node_id],
            [rank],
            [parent_node_id],
            [node_name],
            @level AS [LEVEL]
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
            [node_name],
            @level AS [LEVEL]
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
            [node_name],
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

    /*
    SELECT
        [result_id],
        [patient_id],
        [orig_patient_id],
        [obs_start_dt],
        [order_id],
        [is_history],
        [monitor_sw],
        [univ_svc_cid],
        [test_cid],
        [history_seq],
        [test_sub_id],
        [order_line_seq_no],
        [test_result_seq_no],
        [result_dt],
        [value_type_cd],
        [specimen_id],
        [source_cid],
        [status_cid],
        [last_normal_dt],
        [probability],
        [obs_id],
        [prin_rslt_intpr_id],
        [asst_rslt_intpr_id],
        [tech_id],
        [trnscrbr_id],
        [result_units_cid],
        [reference_range_id],
        [abnormal_cd],
        [abnormal_nature_cd],
        [prov_svc_cid],
        [nsurv_tfr_ind],
        [result_value],
        [result_text],
        [result_comment],
        [has_history],
        [mod_dt],
        [mod_user_id],
        [Sequence],
        [result_ft]
    FROM
        [dbo].[int_result]
    WHERE
        [patient_id] = @patient_id
        AND [obs_start_dt] <= @max_date
        AND [obs_start_dt] >= @min_date
        AND ([is_history] IS NULL
        OR [is_history] = 0
        );
    */

    SELECT
        [tn].[rank] AS [NODERANK],
        [tn].[node_id],
        [tn].[node_name],
        [alias_test_cid] AS [ALIAS],
        [itgd].[source_cid] AS [TGD_SOURCE_CID],
        [itgd].[rank] AS [DETRANK],
        [itgd].[nm],
        [itgd].[display_type],
        'rtTest' AS [TEST_TYPE],
        [imc].[sys_id],
        [obs_start_dt],
        [order_id],
        [ir].[univ_svc_cid],
        [ir].[test_cid],
        [history_seq],
        [test_sub_id],
        [order_line_seq_no],
        [test_result_seq_no],
        [result_dt],
        [value_type_cd],
        [specimen_id],
        [ir].[source_cid],
        [status_cid],
        [result_units_cid],
        [reference_range_id],
        [abnormal_cd],
        [nsurv_tfr_ind],
        [prin_rslt_intpr_id],
        [result_value],
        CONVERT (VARCHAR(10), [result_comment]) AS [RESULT_COMMENT]
    INTO
        [#TMP_RESULTS]
    FROM
        [#TMP_NODES] AS [tn]
        INNER JOIN [dbo].[int_test_group_detail] AS [itgd] ON [tn].[node_id] = [itgd].[node_id]
        INNER JOIN [dbo].[int_result] AS [ir] ON [itgd].[test_cid] = [ir].[test_cid]
        INNER JOIN [dbo].[int_misc_code] AS [imc] ON [ir].[test_cid] = [imc].[code_id]
    WHERE
        [patient_id] = @patient_id
        AND [obs_start_dt] <= @max_date
        AND [obs_start_dt] >= @min_date
        AND (([is_history] IS NULL)
        OR ([is_history] = 0)
        )
    UNION
    SELECT DISTINCT
        [tn].[rank] AS [NODERANK],
        [tn].[node_id],
        [tn].[node_name],
        [alias_univ_svc_cid] AS [ALIAS],
        [itgd].[source_cid] AS [TGD_SOURCE_CID],
        [itgd].[rank] AS [DETRANK],
        [itgd].[nm],
        [itgd].[display_type],
        'rtUsid' [TEST_TYPE],
        [imc].[sys_id],
        [obs_start_dt],
        [order_id],
        [ir].[univ_svc_cid],
        NULL [TEST_CID],
        [history_seq],
        NULL [TEST_SUB_ID],
        [order_line_seq_no],
        NULL [TEST_RESULT_SEQ_NO],
        [result_dt],
        NULL [VALUE_TYPE_CD],
        [specimen_id],
        [ir].[source_cid],
        NULL [STATUS_CID],
        NULL [RESULT_UNITS_CID],
        NULL [REFERENCE_RANGE_ID],
        [abnormal_cd],
        [nsurv_tfr_ind],
        [prin_rslt_intpr_id],
        NULL [RESULT_VALUE],
        CONVERT(VARCHAR(10), [result_comment]) AS [RESULT_COMMENT]
    FROM
        [#TMP_NODES] AS [tn]
        INNER JOIN [dbo].[int_test_group_detail] AS [itgd] ON [tn].[node_id] = [itgd].[node_id]
        INNER JOIN [dbo].[int_result] AS [ir] ON [itgd].[univ_svc_cid] = [ir].[univ_svc_cid]
        INNER JOIN [dbo].[int_misc_code] AS [imc] ON [ir].[univ_svc_cid] = [imc].[code_id]
    WHERE
        [patient_id] = @patient_id
        AND [obs_start_dt] <= @max_date
        AND [obs_start_dt] >= @min_date
        AND ([is_history] IS NULL
        OR [is_history] = 0
        );

    SELECT DISTINCT
        [int_patient_image].[order_id],
        1 AS [HAS_IMAGE]
    INTO
        [#TMP_IMAGES]
    FROM
        [#TMP_RESULTS]
        INNER JOIN [dbo].[int_patient_image] ON [#TMP_RESULTS].[order_id] = [int_patient_image].[order_id]
    WHERE
        [int_patient_image].[patient_id] = @patient_id;

    SELECT
        [tr].[NODERANK],
        [tr].[node_id],
        [tr].[node_name],
        [tr].[ALIAS],
        [tr].[TGD_SOURCE_CID],
        [tr].[DETRANK],
        [tr].[nm],
        [tr].[display_type],
        [tr].[TEST_TYPE],
        [tr].[sys_id],
        [tr].[obs_start_dt],
        [tr].[order_id],
        [tr].[univ_svc_cid],
        [tr].[test_cid],
        [tr].[history_seq],
        [tr].[test_sub_id],
        [tr].[order_line_seq_no],
        [tr].[test_result_seq_no],
        [tr].[result_dt],
        [tr].[value_type_cd],
        [tr].[specimen_id],
        [tr].[source_cid],
        [tr].[status_cid],
        [tr].[result_units_cid],
        [tr].[reference_range_id],
        [tr].[abnormal_cd],
        [tr].[nsurv_tfr_ind],
        [tr].[prin_rslt_intpr_id],
        [tr].[result_value],
        [tr].[RESULT_COMMENT],
        [imc].[code] AS [SOURCE_CD],
        [RR].[reference_range],
        [PN].[last_nm],
        [PN].[first_nm],
        [PN].[middle_nm],
        [PN].[suffix],
        [int_order].[status_cid] AS [ORDER_STATUS_CID],
        [HAS_IMAGE],
        [int_order].[encounter_id]
    FROM
        [#TMP_RESULTS] AS [tr]
        LEFT OUTER JOIN [dbo].[int_reference_range] AS [RR] ON [tr].[reference_range_id] = [RR].[reference_range_id]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [imc] ON [tr].[source_cid] = [imc].[code_id]
        LEFT OUTER JOIN [dbo].[int_person_name] AS [PN] ON [tr].[prin_rslt_intpr_id] = [PN].[person_nm_id]
        LEFT OUTER JOIN [dbo].[int_order] ON [tr].[order_id] = [int_order].[order_id]
        LEFT OUTER JOIN [#TMP_IMAGES] ON [tr].[order_id] = [#TMP_IMAGES].[order_id];

    DROP TABLE [#TMP_NODES];

    DROP TABLE [#TMP_RESULTS];

    DROP TABLE [#TMP_IMAGES];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Node_Results';

