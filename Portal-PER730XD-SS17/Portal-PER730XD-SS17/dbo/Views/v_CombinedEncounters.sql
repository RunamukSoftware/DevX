
CREATE VIEW [dbo].[v_CombinedEncounters]
WITH
     SCHEMABINDING
AS
SELECT
    [FIRST_NAME],
    [LAST_NAME],
    [MRN_ID],
    [ACCOUNT_ID],
    [DOB],
    [FACILITY_ID],
    [UNIT_ID],
    [ROOM],
    [BED],
    [MONITOR_NAME],
    --[dbo].[fnUtcDateTimeToLocalTime]([LAST_RESULT_UTC]) AS [LAST_RESULT],
    --[dbo].[fnUtcDateTimeToLocalTime]([ADMIT_TIME_UTC]) AS [ADMIT],
    --[dbo].[fnUtcDateTimeToLocalTime]([DISCHARGED_TIME_UTC]) AS [DISCHARGED],
    [LAST_RESULT].[LocalDateTime] AS [LAST_RESULT],
    [ADMIT].[LocalDateTime] AS [ADMIT],
    [DISCHARGED].[LocalDateTime] AS [DISCHARGED],
    [SUBNET],
    [patient_id],
    [STATUS_CD] = CASE [STATUS]
                    WHEN 'A' THEN 'C'
                    WHEN 'S' THEN 'C'
                    ELSE 'D'
                  END,
    [MONITOR_CREATED] = 1,
    [FACILITY_PARENT_ID] = [int_organization].[parent_organization_id],
    [PATIENT_MONITOR_ID],
    [MERGE_CD] = 'C'
FROM
    [dbo].[v_PatientSessions]
    INNER JOIN [dbo].[int_organization] ON [int_organization].[organization_id] = [FACILITY_ID]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([LAST_RESULT_UTC]) AS [LAST_RESULT]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([ADMIT_TIME_UTC]) AS [ADMIT]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([DISCHARGED_TIME_UTC]) AS [DISCHARGED]

UNION ALL

SELECT
    [FIRST_NAME] = ISNULL([int_person].[first_nm], ''),
    [LAST_NAME] = ISNULL([int_person].[last_nm], ''),
    [MRN_ID] = [int_mrn_map].[mrn_xid],
    [ACCOUNT_ID] = [int_mrn_map].[mrn_xid2],
    [DOB] = [int_patient].[dob],
    [FACILITY_ID] = [org1].[organization_id],
    [UNIT_ID] = [org2].[organization_id],
    [ROOM] = [int_encounter].[rm],
    [BED] = [int_encounter].[bed],
    [MONITOR_NAME] = [int_monitor].[monitor_name],
    [LAST_RESULT] = [PM1].[last_result_dt],
    [ADMIT] = [int_encounter].[admit_dt],
    [DISCHARGED] = [int_encounter].[discharge_dt],
    [SUBNET] = [int_monitor].[subnet],
    [patient_id] = [int_mrn_map].[patient_id],
    [STATUS_CD] = [int_encounter].[status_cd],
    [MONITOR_CREATED] = [int_encounter].[monitor_created],
    [FACILITY_PARENT_ID] = [org1].[parent_organization_id],
    [PATIENT_MONITOR_ID] = [PM1].[patient_monitor_id],
    [MERGE_CD] = [int_mrn_map].[merge_cd]
FROM
    [dbo].[int_encounter]
    LEFT OUTER JOIN [dbo].[int_organization] AS [org1] ON ([int_encounter].[organization_id] = [org1].[organization_id])
    LEFT OUTER JOIN [dbo].[int_patient_monitor] AS [PM1]
    INNER JOIN [dbo].[int_monitor] ON ([PM1].[monitor_id] = [int_monitor].[monitor_id]) ON ([int_encounter].[encounter_id] = [PM1].[encounter_id])
    LEFT OUTER JOIN [dbo].[int_patient_monitor] AS [PM2] ON [PM2].[patient_monitor_id] <> [PM1].[patient_monitor_id]
                                                            AND [int_encounter].[encounter_id] = [PM2].[encounter_id]
                                                            AND [PM1].[last_result_dt] < [PM2].[last_result_dt]
    INNER JOIN [dbo].[int_person] ON ([int_encounter].[patient_id] = [int_person].[person_id])
    INNER JOIN [dbo].[int_patient] ON ([int_person].[person_id] = [int_patient].[patient_id])
    INNER JOIN [dbo].[int_mrn_map] ON ([int_patient].[patient_id] = [int_mrn_map].[patient_id])
    INNER JOIN [dbo].[int_organization] AS [org2] ON ([int_encounter].[unit_org_id] = [org2].[organization_id])
WHERE
    [PM2].[encounter_id] IS NULL;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_CombinedEncounters';

