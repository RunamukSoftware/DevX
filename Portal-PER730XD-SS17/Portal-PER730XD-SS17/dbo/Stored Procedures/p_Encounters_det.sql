CREATE PROCEDURE [dbo].[p_Encounters_det]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DECLARE
        @acct_no CHAR(40) = 'SEE DETAIL',
        @diagnosis VARCHAR(255) = ' ',
        @pat_type VARCHAR(30) = '',
        @pat_class VARCHAR(30) = '';

    SELECT DISTINCT
        @acct_no AS [tmp_acct_xid],
        [A].[account_id] AS [TMP_ACCT_ID],
        [A].[encounter_id] AS [TMP_ENC_ID],
        [C].[encounter_xid] AS [TMP_ENC_XID],
        [A].[patient_type_cid] AS [tmp_pat_type_id],
        @pat_type AS [TMP_PAT_TYPE],
        [A].[patient_class_cid] AS [TMP_PAT_CLASS_ID],
        @pat_class AS [TMP_PAT_CLASS],
        [A].[admit_dt] AS [tmp_admit_dt],
        [A].[discharge_dt] AS [TMP_DISCH_DT],
        [A].[med_svc_cid] AS [TMP_MED_SRVC_ID],
        SPACE(20) AS [tmp_med_srvc],
        0 AS [TMP_DIAG_ID],
        @diagnosis AS [TMP_DIAGNOSIS],
        [A].[attend_hcp_id] AS [TMP_DR_ID],
        [A].[status_cd] AS [TMP_ENC_STATUS_CD],
        [B].[last_nm] AS [TMP_DR_LAST_NAME],
        [B].[first_nm] AS [TMP_DR_FIRST_NAME],
        [B].[middle_nm] AS [TMP_DR_MIDDLE_NAME],
        [C].[status_cd] AS [TMP_ENC_MAP_STATUS_CD],
        [C].[event_cd] AS [TMP_STAT_ACT_CODE],
        [A].[vip_sw] AS [TMP_VIP_SW],
        SPACE(20) AS [tmp_dept_code],
        [A].[unit_org_id] AS [TMP_DEPT_ID],
        [A].[rm] AS [TMP_ROOM],
        [A].[bed] AS [TMP_BED],
        [A].[discharge_dispo_cid] AS [TMP_DISPO_CID]
    INTO
        [#ENCOUNTERS]
    FROM
        [dbo].[int_encounter] AS [A]
        LEFT OUTER JOIN [dbo].[int_hcp] AS [B] ON [A].[attend_hcp_id] = [B].[hcp_id]
        INNER JOIN [dbo].[int_encounter_map] AS [C] ON [C].[encounter_id] = [A].[encounter_id]
    WHERE
        @patient_id = [C].[patient_id]
        AND [C].[status_cd] IN (N'N', N'S', N'C')
        AND ([A].[status_cd] != N'X'
        OR [A].[status_cd] IS NULL
        ); /* filter canceled encounters */

    UPDATE
        [#ENCOUNTERS]
    SET
        [TMP_DIAGNOSIS] = ISNULL([dsc], ' '),
        [TMP_DIAG_ID] = ISNULL([diagnosis_cid], 0)
    FROM
        [#ENCOUNTERS] AS [A]
        INNER JOIN [dbo].[int_diagnosis] AS [B] ON [A].[TMP_ENC_ID] = [B].[encounter_id]
    WHERE
        [B].[inactive_sw] IS NULL
        AND [B].[seq_no] = (SELECT
                                MAX([seq_no])
                            FROM
                                [#ENCOUNTERS] AS [A]
                                INNER JOIN [dbo].[int_diagnosis] AS [B] ON [A].[TMP_ENC_ID] = [B].[encounter_id]
                            WHERE
                                [inactive_sw] IS NULL
                           );

    --Update each of the records in the temporary table that have an account number and have not been moved or merged
    UPDATE
        [#ENCOUNTERS]
    SET
        [tmp_acct_xid] = [int_account].[account_xid]
    FROM
        [#ENCOUNTERS]
        INNER JOIN [dbo].[int_encounter] ON [#ENCOUNTERS].[TMP_ENC_ID] = [int_encounter].[encounter_id]
        INNER JOIN [dbo].[int_account] ON [int_encounter].[account_id] = [int_account].[account_id]
    WHERE
        [int_encounter].[patient_id] = @patient_id
        AND [int_account].[account_xid] IS NOT NULL
        AND [TMP_ENC_MAP_STATUS_CD] != N'N';

    --update each of the records in the temporary table that do not have an account number and have not been moved or merged
    UPDATE
        [#ENCOUNTERS]
    SET
        [tmp_acct_xid] = '*NOT AVAILABLE*'
    FROM
        [#ENCOUNTERS]
    WHERE
        [tmp_acct_xid] = @acct_no
        AND /* SEE DETAIL */ [TMP_ENC_MAP_STATUS_CD] != N'N'
        AND [TMP_ENC_MAP_STATUS_CD] != N'S';

    UPDATE
        [#ENCOUNTERS]
    SET
        [TMP_DIAGNOSIS] = [short_dsc]
    FROM
        [#ENCOUNTERS]
        INNER JOIN [dbo].[int_misc_code] ON [TMP_DIAG_ID] = [code_id]
    WHERE
        [TMP_DIAG_ID] != 0;

    --Retrieve patient class and type from misc_code; ignore if short_dsc is NULL
    UPDATE
        [#ENCOUNTERS]
    SET
        [TMP_PAT_TYPE] = ISNULL([M].[short_dsc], N''),
        [TMP_PAT_CLASS] = ISNULL([M2].[short_dsc], N'')
    FROM
        [#ENCOUNTERS]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [M] ON ([tmp_pat_type_id] = [M].[code_id])
        INNER JOIN [dbo].[int_misc_code] AS [M2] ON [TMP_PAT_CLASS_ID] = [M2].[code_id];

    --Retrieve medical service from misc_code; ignore if short_dsc is NULL
    UPDATE
        [#ENCOUNTERS]
    SET
        [tmp_med_srvc] = [short_dsc]
    FROM
        [#ENCOUNTERS]
        INNER JOIN [dbo].[int_misc_code] ON [TMP_MED_SRVC_ID] = [code_id]
    WHERE
        [short_dsc] IS NOT NULL;

    UPDATE
        [#ENCOUNTERS]
    SET
        [tmp_dept_code] = [organization_cd]
    FROM
        [dbo].[int_organization]
    WHERE
        [#ENCOUNTERS].[TMP_DEPT_ID] = [int_organization].[organization_id];

    --Data has been built now select out all data
    SELECT
        [tmp_acct_xid],
        [TMP_ENC_ID],
        [TMP_ACCT_ID],
        [TMP_PAT_TYPE],
        [tmp_admit_dt],
        [TMP_DISCH_DT],
        [tmp_med_srvc],
        [TMP_DIAGNOSIS],
        [TMP_ENC_STATUS_CD],
        [TMP_DR_ID],
        [TMP_DR_LAST_NAME],
        [TMP_DR_FIRST_NAME],
        [TMP_DR_MIDDLE_NAME],
        [TMP_ENC_MAP_STATUS_CD],
        [TMP_ENC_XID],
        [TMP_STAT_ACT_CODE],
        [TMP_PAT_CLASS],
        [TMP_VIP_SW],
        [tmp_dept_code],
        [TMP_DEPT_ID],
        [TMP_ROOM],
        [TMP_BED],
        [TMP_DISPO_CID]
    FROM
        [#ENCOUNTERS]
    ORDER BY
        [tmp_admit_dt] DESC;

    DROP TABLE [#ENCOUNTERS];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Encounters_det';

