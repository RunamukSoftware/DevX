CREATE PROCEDURE [dbo].[p_Ins_Guarantor]
    (
     @patient_id UNIQUEIDENTIFIER,
     @enc_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE
    --    @acct_id UNIQUEIDENTIFIER,
    --    @gu_id UNIQUEIDENTIFIER,
    --    @gu_lname VARCHAR(50),
    --    @gu_fname VARCHAR(50),
    --    @gu_mname VARCHAR(50),
    --    @pat_rel VARCHAR(30),
    --    @pat_rel_id INT,
    --    @gu_addr1 VARCHAR(50),
    --    @gu_addr2 VARCHAR(50),
    --    @gu_addr3 VARCHAR(50),
    --    @gu_city VARCHAR(25),
    --    @gu_state CHAR(3),
    --    @gu_zip CHAR(10),
    --    @gu_country_code_id INT,
    --    @gu_home_ph CHAR(40),
    --    @gu_home_ext CHAR(12),
    --    @gu_work_ph CHAR(40),
    --    @gu_work_ext CHAR(12),
    --    @gu_emer_ph CHAR(40),
    --    @gu_emer_ext CHAR(5),
    --    @emplyr_id UNIQUEIDENTIFIER,
    --    @emplyr_nm VARCHAR(50),
    --    @emplyr_addr1 VARCHAR(50),
    --    @emplyr_addr2 VARCHAR(50),
    --    @emplyr_addr3 VARCHAR(50),
    --    @emplyr_city VARCHAR(25),
    --    @emplyr_state CHAR(3),
    --    @emplyr_zip CHAR(10),
    --    @emplyr_country_code_id INT,
    --    @emplyr_work_ph CHAR(40),
    --    @emplyr_work_ext CHAR(5),
    --    @emplyr_emer_ph CHAR(40),
    --    @emplyr_emer_ext CHAR(5),
    --    @seq_no INT;

    ----Look up the acct_id in the encounter
    --SELECT
    --    @acct_id = [account_id]
    --FROM
    --    [dbo].[int_encounter]
    --WHERE
    --    [patient_id] = @patient_id
    --    AND [encounter_id] = @enc_id;

    ----Look up the latest desc_key for this account
    --SELECT
    --    @seq_no = MAX([seq_no])
    --FROM
    --    [dbo].[int_guarantor]
    --WHERE
    --    [patient_id] = @patient_id
    --    AND [encounter_id] = @enc_id
    --    AND [active_sw] = 1;

    --SELECT
    --    @gu_id = [ig].[guarantor_person_id],
    --    @emplyr_id = [ig].[employer_id]
    --FROM
    --    [dbo].[int_guarantor] AS [ig]
    --WHERE
    --    [ig].[patient_id] = @patient_id
    --    AND [ig].[encounter_id] = @enc_id
    --    AND [ig].[seq_no] = @seq_no;

    --SELECT
    --    @pat_rel = [imc].[short_dsc],
    --    @pat_rel_id = [ig].[relationship_cid]
    --FROM
    --    [dbo].[int_guarantor] AS [ig],
    --    [dbo].[int_misc_code] AS [imc]
    --WHERE
    --    [ig].[patient_id] = @patient_id
    --    AND ([ig].[encounter_id] = @enc_id
    --    OR [ig].[encounter_id] IS NULL
    --    )
    --    AND [ig].[guarantor_person_id] = @gu_id
    --    AND [ig].[relationship_cid] = [imc].[code_id];

    --IF (@pat_rel_id = NULL)
    --BEGIN
    --    SELECT
    --        @pat_rel = [imc].[short_dsc],
    --        @pat_rel_id = [ig].[relationship_cid]
    --    FROM
    --        [dbo].[int_guarantor] AS [ig],
    --        [dbo].[int_misc_code] AS [imc]
    --    WHERE
    --        [ig].[patient_id] = @patient_id
    --        AND ([ig].[encounter_id] = @enc_id
    --        OR [ig].[encounter_id] IS NULL
    --        )
    --        AND [ig].[company_id] = @gu_id
    --        AND [ig].[relationship_cid] = [imc].[code_id];
    --END;

    --SELECT
    --    @gu_lname = [last_nm],
    --    @gu_fname = [first_nm],
    --    @gu_mname = [middle_nm]
    --FROM
    --    [dbo].[int_person_name]
    --WHERE
    --    [person_nm_id] = @gu_id
    --    AND [recognize_nm_cd] = 'P'
    --    AND [active_sw] = 1;

    ----Use the ent_id of the guarantor as the key to get the
    ----address from the address table
    --SELECT
    --    @gu_addr1 = [line1_dsc],
    --    @gu_addr2 = [line2_dsc],
    --    @gu_addr3 = [line3_dsc],
    --    @gu_city = [city_nm],
    --    @gu_state = [state_code],
    --    @gu_zip = [zip_code],
    --    @gu_country_code_id = [country_cid]
    --FROM
    --    [dbo].[int_address]
    --WHERE
    --    [address_id] = @gu_id;

    --SELECT
    --    @emplyr_addr1 = [A].[line1_dsc],
    --    @emplyr_addr2 = [A].[line2_dsc],
    --    @emplyr_addr3 = [A].[line3_dsc],
    --    @emplyr_city = [A].[city_nm],
    --    @emplyr_state = [A].[state_code],
    --    @emplyr_zip = [A].[zip_code],
    --    @emplyr_country_code_id = [A].[country_cid]
    --FROM
    --    [dbo].[int_address] AS [A]
    --WHERE
    --    [A].[address_id] = @emplyr_id
    --    AND [A].[addr_type_cd] = N'M';

    --SELECT
    --    @emplyr_nm = [organization_nm]
    --FROM
    --    [dbo].[int_external_organization]
    --WHERE
    --    [ext_organization_id] = @emplyr_id;

    ----Look up the guarantor's home phone number
    --SELECT
    --    @gu_home_ph = [tel_no],
    --    @gu_home_ext = [ext_no]
    --FROM
    --    [dbo].[int_telephone]
    --WHERE
    --    @gu_id = [phone_id]
    --    AND [phone_loc_cd] = 'R'
    --    AND [phone_type_cd] = 'V'
    --ORDER BY
    --    [seq_no] DESC; /* the one with min seq_no */

    ----Look up the guarantor's work phone number
    --SELECT
    --    @gu_work_ph = [tel_no],
    --    @gu_work_ext = [ext_no]
    --FROM
    --    [dbo].[int_telephone]
    --WHERE
    --    @gu_id = [phone_id]
    --    AND [phone_loc_cd] = 'B'
    --    AND [phone_type_cd] = 'V'
    --ORDER BY
    --    [seq_no] DESC; /* the one with min seq_no*/

    ----Look up the guarantor's emergency home phone number
    --SELECT
    --    @gu_emer_ph = [tel_no],
    --    @gu_emer_ext = [ext_no]
    --FROM
    --    [dbo].[int_telephone]
    --WHERE
    --    @gu_id = [phone_id]
    --    AND [phone_loc_cd] = 'E'
    --    AND [phone_type_cd] = 'V'
    --ORDER BY
    --    [seq_no] DESC; /* the one with min seq_no */

    ----Look up the employer's work phone number
    --SELECT
    --    @emplyr_work_ph = [tel_no],
    --    @emplyr_work_ext = [ext_no]
    --FROM
    --    [dbo].[int_telephone]
    --WHERE
    --    @emplyr_id = [phone_id]
    --    AND [phone_loc_cd] = 'B'
    --    AND [phone_type_cd] = 'V'
    --ORDER BY
    --    [seq_no] DESC; /* the one with min seq_no */

    ----Look up the employer's emergency work phone number
    --SELECT
    --    @emplyr_emer_ph = [tel_no],
    --    @emplyr_emer_ext = [ext_no]
    --FROM
    --    [dbo].[int_telephone]
    --WHERE
    --    @emplyr_id = [phone_id]
    --    AND [phone_loc_cd] = 'M'
    --    AND [phone_type_cd] = 'V'
    --ORDER BY
    --    [seq_no] DESC; /* the one with min seq_no */

    --SELECT
    --    @gu_id AS [ID],
    --    @gu_lname AS [LAST],
    --    @gu_fname AS [FIRST],
    --    @gu_mname AS [MIDDLE],
    --    @pat_rel AS [RELATION],
    --    @pat_rel_id AS [RELATION_CODE_ID],
    --    @gu_addr1 AS [ADDR1],
    --    @gu_addr2 AS [ADDR2],
    --    @gu_addr3 AS [ADDR3],
    --    @gu_city AS [CITY],
    --    @gu_state AS [STATE],
    --    @gu_zip AS [ZIP],
    --    @gu_country_code_id AS [COUNTRY_CODE_ID],
    --    @gu_home_ph AS [H_PHONE],
    --    @gu_home_ext AS [HOME_EXT],
    --    @gu_work_ph AS [W_PHONE],
    --    @gu_work_ext AS [WORK_EXT],
    --    @gu_emer_ph AS [EMR_PHONE],
    --    @gu_emer_ext AS [EMR_EXT],
    --    @emplyr_id AS [EMPL_ID],
    --    @emplyr_nm AS [EMPL_NAME],
    --    @emplyr_addr1 AS [EMPL_ADDR1],
    --    @emplyr_addr2 AS [EMPL_ADDR2],
    --    @emplyr_addr3 AS [EMPL_ADDR3],
    --    @emplyr_city AS [EMP_CITY],
    --    @emplyr_state AS [EMP_ST],
    --    @emplyr_zip AS [EMP_ZIP],
    --    @emplyr_country_code_id AS [EMP_COUNTRY_CODE_ID],
    --    @emplyr_work_ph AS [EMP_PHONE],
    --    @emplyr_work_ext AS [EMP_EXT],
    --    @emplyr_emer_ph AS [EMP_EMR_PHONE],
    --    @emplyr_emer_ext AS [EMP_RMR_EXT];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Ins_Guarantor';

