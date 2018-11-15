CREATE PROCEDURE [dbo].[p_Pat_Summary] (@mrn CHAR(30))
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @pat_id UNIQUEIDENTIFIER;

    SELECT
        @pat_id = [patient_id]
    FROM
        [dbo].[int_mrn_map]
    WHERE
        [mrn_xid] = @mrn;

    IF (@pat_id IS NULL)
        SELECT
            'Patient not found ....';
    ELSE
    BEGIN
        SELECT
            'PATIENT    ',
            [ip].[patient_id],
            [ip].[new_patient_id],
            [ip].[organ_donor_sw],
            [ip].[living_will_sw],
            [ip].[birth_order],
            [ip].[veteran_status_cid],
            [ip].[birth_place],
            [ip].[ssn],
            [ip].[mpi_ssn1],
            [ip].[mpi_ssn2],
            [ip].[mpi_ssn3],
            [ip].[mpi_ssn4],
            [ip].[driv_lic_no],
            [ip].[mpi_dl1],
            [ip].[mpi_dl2],
            [ip].[mpi_dl3],
            [ip].[mpi_dl4],
            [ip].[driv_lic_state_code],
            [ip].[dob],
            [ip].[death_dt],
            [ip].[nationality_cid],
            [ip].[citizenship_cid],
            [ip].[ethnic_group_cid],
            [ip].[race_cid],
            [ip].[gender_cid],
            [ip].[primary_language_cid],
            [ip].[marital_status_cid],
            [ip].[religion_cid],
            [ip].[monitor_interval],
            [ip].[height],
            [ip].[weight],
            [ip].[bsa]
        FROM
            [dbo].[int_patient] AS [ip]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'PATIENT_MON' AS [PATIENT_MON],
            [ipm].[patient_monitor_id],
            [ipm].[patient_id],
            [ipm].[orig_patient_id],
            [ipm].[monitor_id],
            [ipm].[monitor_interval],
            [ipm].[poll_type],
            [ipm].[monitor_connect_dt],
            [ipm].[monitor_connect_num],
            [ipm].[disable_sw],
            [ipm].[last_poll_dt],
            [ipm].[last_result_dt],
            [ipm].[last_episodic_dt],
            [ipm].[poll_start_dt],
            [ipm].[poll_end_dt],
            [ipm].[last_outbound_dt],
            [ipm].[monitor_status],
            [ipm].[monitor_error],
            [ipm].[encounter_id],
            [ipm].[live_until_dt],
            [ipm].[active_sw]
        FROM
            [dbo].[int_patient_monitor] AS [ipm]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'PERSON_NAME' AS [PERSON_NAME],
            [ipn].[person_nm_id],
            [ipn].[recognize_nm_cd],
            [ipn].[seq_no],
            [ipn].[orig_patient_id],
            [ipn].[active_sw],
            [ipn].[prefix],
            [ipn].[first_nm],
            [ipn].[middle_nm],
            [ipn].[last_nm],
            [ipn].[suffix],
            [ipn].[degree],
            [ipn].[mpi_lname_cons],
            [ipn].[mpi_fname_cons],
            [ipn].[mpi_mname_cons],
            [ipn].[start_dt]
        FROM
            [dbo].[int_person_name] AS [ipn]
        WHERE
            [person_nm_id] = @pat_id;

        SELECT
            'PERSON     ' AS [PERSON],
            [ip].[person_id],
            [ip].[new_patient_id],
            [ip].[first_nm],
            [ip].[middle_nm],
            [ip].[last_nm],
            [ip].[suffix],
            [ip].[tel_no],
            [ip].[line1_dsc],
            [ip].[line2_dsc],
            [ip].[line3_dsc],
            [ip].[city_nm],
            [ip].[state_code],
            [ip].[zip_code],
            [ip].[country_cid]
        FROM
            [dbo].[int_person] AS [ip]
        WHERE
            [person_id] = @pat_id;

        SELECT
            'MRN_MAP    ' AS [MRN_MAP],
            [imm].[organization_id],
            [imm].[mrn_xid],
            [imm].[patient_id],
            [imm].[orig_patient_id],
            [imm].[merge_cd],
            [imm].[prior_patient_id],
            [imm].[mrn_xid2],
            [imm].[adt_adm_sw]
        FROM
            [dbo].[int_mrn_map] AS [imm]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'ENCOUNTER  ' AS [ENCOUNTER],
            [ie].[encounter_id],
            [ie].[organization_id],
            [ie].[mod_dt],
            [ie].[patient_id],
            [ie].[orig_patient_id],
            [ie].[account_id],
            [ie].[status_cd],
            [ie].[publicity_cid],
            [ie].[diet_type_cid],
            [ie].[patient_class_cid],
            [ie].[protection_type_cid],
            [ie].[vip_sw],
            [ie].[isolation_type_cid],
            [ie].[security_type_cid],
            [ie].[patient_type_cid],
            [ie].[admit_hcp_id],
            [ie].[med_svc_cid],
            [ie].[referring_hcp_id],
            [ie].[unit_org_id],
            [ie].[attend_hcp_id],
            [ie].[primary_care_hcp_id],
            [ie].[fall_risk_type_cid],
            [ie].[begin_dt],
            [ie].[ambul_status_cid],
            [ie].[admit_dt],
            [ie].[baby_cd],
            [ie].[rm],
            [ie].[recurring_cd],
            [ie].[bed],
            [ie].[discharge_dt],
            [ie].[newborn_sw],
            [ie].[discharge_dispo_cid],
            [ie].[monitor_created],
            [ie].[comment]
        FROM
            [dbo].[int_encounter] AS [ie]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'ORDER_MAP  ' AS [ORDER_MAP],
            [iom].[order_id],
            [iom].[patient_id],
            [iom].[orig_patient_id],
            [iom].[organization_id],
            [iom].[sys_id],
            [iom].[order_xid],
            [iom].[type_cd],
            [iom].[seq_no]
        FROM
            [dbo].[int_order_map] AS [iom]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'ORDER      ' AS [ORDER],
            [io].[encounter_id],
            [io].[order_id],
            [io].[patient_id],
            [io].[orig_patient_id],
            [io].[priority_cid],
            [io].[status_cid],
            [io].[univ_svc_cid],
            [io].[order_person_id],
            [io].[order_dt],
            [io].[enter_id],
            [io].[verif_id],
            [io].[transcriber_id],
            [io].[parent_order_id],
            [io].[child_order_sw],
            [io].[order_cntl_cid],
            [io].[history_sw],
            [io].[monitor_sw]
        FROM
            [dbo].[int_order] AS [io]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'ORDER_LINE ' AS [ORDER_LINE],
            [iol].[order_id],
            [iol].[seq_no],
            [iol].[patient_id],
            [iol].[orig_patient_id],
            [iol].[status_cid],
            [iol].[prov_svc_cid],
            [iol].[univ_svc_cid],
            [iol].[transport_cid],
            [iol].[order_line_comment],
            [iol].[clin_info_comment],
            [iol].[reason_comment],
            [iol].[scheduled_dt],
            [iol].[observ_dt],
            [iol].[status_chg_dt]
        FROM
            [dbo].[int_order_line] AS [iol]
        WHERE
            [patient_id] = @pat_id;

        SELECT
            'RESULT     ' AS [RESULT],
            [ir].[result_id],
            [ir].[patient_id],
            [ir].[orig_patient_id],
            [ir].[obs_start_dt],
            [ir].[order_id],
            [ir].[is_history],
            [ir].[monitor_sw],
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
            [ir].[last_normal_dt],
            [ir].[probability],
            [ir].[obs_id],
            [ir].[prin_rslt_intpr_id],
            [ir].[asst_rslt_intpr_id],
            [ir].[tech_id],
            [ir].[trnscrbr_id],
            [ir].[result_units_cid],
            [ir].[reference_range_id],
            [ir].[abnormal_cd],
            [ir].[abnormal_nature_cd],
            [ir].[prov_svc_cid],
            [ir].[nsurv_tfr_ind],
            [ir].[result_value],
            [ir].[result_text],
            [ir].[result_comment],
            [ir].[has_history],
            [ir].[mod_dt],
            [ir].[mod_user_id],
            [ir].[Sequence],
            [ir].[result_ft]
        FROM
            [dbo].[int_result] AS [ir]
        WHERE
            [patient_id] = @pat_id;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Pat_Summary';

