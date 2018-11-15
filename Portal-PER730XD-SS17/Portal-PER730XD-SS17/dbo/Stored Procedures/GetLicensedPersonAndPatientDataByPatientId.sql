CREATE PROCEDURE [dbo].[GetLicensedPersonAndPatientDataByPatientId]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @monitot_id AS UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [ORG].[organization_cd] AS [UNITNAME],
        [MRN].[mrn_xid] AS [MRN],
        [ENC].[patient_type_cid] AS [PATIENTTYPE],
        [ENC].[med_svc_cid] AS [HOSPSERVICE],
        [ENC].[patient_class_cid] AS [PATIENTCLASS],
        [ENC].[ambul_status_cid] AS [AMBULATORYSTS],
        [ENC].[vip_sw] AS [VIPINDIC],
        [ENC].[discharge_dispo_cid] AS [DISCHDISPOSITION],
        [ENC].[admit_dt] AS [ADMITDATE],
        [ENC].[discharge_dt] AS [DISCHARGEDT],
        [ENCMAP].[encounter_xid] AS [VISITNUMBER],
        [ENCMAP].[seq_no] AS [SEQNO],
        [MON].[monitor_name] AS [NODENAME],
        [MON].[node_id] AS [NODEID],
        [MON].[room] AS [ROOM],
        [MON].[bed_cd] AS [BED],
        [PAT].[dob] AS [DATEOFBIRTH],
        [PAT].[gender_cid] AS [GENDERCD],
        [PAT].[race_cid] AS [RACECD],
        [PAT].[primary_language_cid] AS [PRIMLANGCODE],
        [PAT].[marital_status_cid] AS [MARITALSTATUSCD],
        [PAT].[religion_cid] AS [RELIGIONCD],
        [PAT].[ssn] AS [SSN],
        [PAT].[driv_lic_no] AS [DLNO],
        [PAT].[driv_lic_state_code] AS [DLSTATECD],
        [PAT].[ethnic_group_cid] AS [ETHNICGRPCD],
        [PAT].[birth_place] AS [BIRTHPLACE],
        [PAT].[birth_order] AS [BIRTHORDER],
        [PAT].[nationality_cid] AS [NATIONALITYCODE],
        [PAT].[citizenship_cid] AS [CITIZENSHIPCODE],
        [PAT].[veteran_status_cid] AS [VETERANSTATUSCODE],
        [PAT].[death_dt] AS [DEATHDATE],
        [PAT].[organ_donor_sw] AS [ORGANDONOR],
        [PAT].[living_will_sw] AS [LIVINGWILL],
        [PERSON].[first_nm] AS [FIRSTNAME],
        [PERSON].[middle_nm] AS [MIDDLENAME],
        [PERSON].[last_nm] AS [LASTNAME],
        [PERSON].[suffix] AS [SUFFIX],
        [PERSON].[tel_no] AS [TELEPHONE],
        [PERSON].[line1_dsc] AS [ADDRESS1],
        [PERSON].[line2_dsc] AS [ADDRESS2],
        [PERSON].[line3_dsc] AS [ADDRESS3],
        [PERSON].[city_nm] AS [CITY],
        [PERSON].[state_code] AS [STATECODE],
        [PERSON].[zip_code] AS [ZIP],
        [PERSON].[country_cid] AS [COUNTRYCODE],
        [MRN].[mrn_xid2] AS [ACCOUNTNUMBER]
    FROM
        [dbo].[int_encounter] AS [ENC]
        INNER JOIN [dbo].[int_mrn_map] AS [MRN] ON [ENC].[patient_id] = [MRN].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [MRN].[patient_id] = [PATMON].[patient_id]
        INNER JOIN [dbo].[int_monitor] AS [MON] ON [PATMON].[monitor_id] = [MON].[monitor_id]
        INNER JOIN [dbo].[int_encounter_map] AS [ENCMAP] ON [PATMON].[encounter_id] = [ENCMAP].[encounter_id]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [MON].[unit_org_id] = [ORG].[organization_id]
        INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ORG].[organization_id] = [ACCESS].[organization_id]
        INNER JOIN [dbo].[int_patient] AS [PAT] ON [ENC].[patient_id] = [PAT].[patient_id]
        INNER JOIN [dbo].[int_person] AS [PERSON] ON [PAT].[patient_id] = [PERSON].[person_id]
    WHERE
        ([MRN].[patient_id] = @patient_id)
        AND [MON].[monitor_id] = @monitot_id
           --AND (patMon.active_sw = 1) 
        AND [ORG].[outbound_interval] > 0
        AND [ACCESS].[product_cd] = 'outHL7'
        AND [ORG].[category_cd] = 'D'
        AND ([ENC].[discharge_dt] IS NULL
        OR [ENC].[discharge_dt] > [ENC].[admit_dt]
        )
        AND ([MRN].[merge_cd] = 'C')
    ORDER BY
        [AdmitDate] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DM3...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLicensedPersonAndPatientDataByPatientId';

