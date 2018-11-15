CREATE PROCEDURE [dbo].[p_Ins_Plcys]
    (
     @patient_id UNIQUEIDENTIFIER,
     @acct_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    -- Select insurance info
    SELECT DISTINCT
        [cob_priority] AS [priority],
        [P].[plan_xid] AS [PLANNO],
        [ins_policy_xid] AS [POLICYNO],
        [I].[group_xid] AS [GROUPNO],
        [I].[seq_no],
        SPACE(50) AS [LASTNAME],
        SPACE(50) AS [FIRSTNAME],
        SPACE(50) AS [MIDDLENAME],
        [I].[holder_rel_cid] AS [RELATIONSHIPID],
        [holder_id] AS [HOLDERID],
        SPACE(50) AS [CARRIER],
        [P].[ins_company_id] AS [EXT_ORGANIZATION_ID]
    INTO
        [#TMP_INS1]
    FROM
        [dbo].[int_insurance_policy] AS [I]
        INNER JOIN [dbo].[int_insurance_plan] AS [P] ON [I].[plan_id] = [P].[plan_id]
    WHERE
        [I].[patient_id] = @patient_id
        AND [I].[account_id] = @acct_id
    ORDER BY
        [priority];

    -- Update external_org
    UPDATE
        [#TMP_INS1]
    SET
        [CARRIER] = [E].[organization_nm]
    FROM
        [#TMP_INS1] AS [A]
        INNER JOIN [dbo].[int_external_organization] AS [E] ON [A].[EXT_ORGANIZATION_ID] = [E].[ext_organization_id];

    -- Update from person_name
    UPDATE
        [#TMP_INS1]
    SET
        [LASTNAME] = ISNULL([last_nm], ''),
        [MIDDLENAME] = ISNULL([middle_nm], ''),
        [FIRSTNAME] = ISNULL([first_nm], '')
    FROM
        [#TMP_INS1]
        INNER JOIN [dbo].[int_person_name] AS [PN] ON [HOLDERID] = [PN].[person_nm_id]
    WHERE
        [PN].[recognize_nm_cd] = 'P'
        AND [PN].[active_sw] = 1;

    -- Contact person address
    SELECT
        [I].[LASTNAME],
        [I].[FIRSTNAME],
        [I].[MIDDLENAME],
        [I].[CARRIER],
        [A].[line1_dsc] AS [ADDR1],
        [A].[line2_dsc] AS [ADDR2],
        [A].[line3_dsc] AS [ADDR3],
        [A].[city_nm] AS [CITY],
        [A].[state_code] AS [STATE],
        [A].[zip_code] AS [ZIP],
        [A].[country_cid],
        SPACE(14) AS [TEL_NO],
        CAST(NULL AS UNIQUEIDENTIFIER) AS [CONTACT_ID]
    INTO
        [#TMP_INS2]
    FROM
        [#TMP_INS1] AS [I]
        RIGHT OUTER JOIN [dbo].[int_address] AS [A] ON [I].[EXT_ORGANIZATION_ID] = [A].[address_id];

    -- Phone
    UPDATE
        [#TMP_INS2]
    SET
        [TEL_NO] = [T].[tel_no]
    FROM
        [#TMP_INS2] AS [I]
        INNER JOIN [dbo].[int_telephone] AS [T] ON [I].[EXT_ORGANIZATION_ID] = [T].[phone_id]
    WHERE
        [T].[phone_loc_cd] = 'B'
        AND [T].[phone_type_cd] = 'V'
        AND [T].[seq_no] = (SELECT
                                MIN([seq_no])
                            FROM
                                [dbo].[int_telephone]
                            WHERE
                                [T].[phone_id] = [phone_id]
                                AND [phone_loc_cd] = 'B'
                                AND [phone_type_cd] = 'V'
                           );

    -- Contact person
    UPDATE
        [#TMP_INS2]
    SET
        [CONTACT_ID] = [IP].[ins_contact_id]
    FROM
        [#TMP_INS2] AS [I]
        INNER JOIN [dbo].[int_insurance_policy] AS [IP] ON [IP].[seq_no] = [I].[seq_no]
    WHERE
        [IP].[patient_id] = @patient_id
        AND [IP].[active_sw] = 1;

    SELECT
        [I].[CARRIER],
        [I].[MIDDLENAME],
        [I].[FIRSTNAME],
        [I].[LASTNAME],
        [I].[TEL_NO],
        [I].[CONTACT_ID],
        [PN].[last_nm] AS [CO_LNAME],
        [PN].[first_nm] AS [CO_FNAME],
        [PN].[middle_nm] AS [CO_MNAME]
    FROM
        [dbo].[int_person_name] AS [PN]
        RIGHT OUTER JOIN [#TMP_INS2] AS [I] ON [I].[CONTACT_ID] = [PN].[person_nm_id]
    WHERE
        [PN].[recognize_nm_cd] = 'P'
        AND [PN].[active_sw] = 1
    ORDER BY
        [priority];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Ins_Plcys';

