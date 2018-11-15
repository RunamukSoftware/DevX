CREATE PROCEDURE [dbo].[GetPatientData]
    (
     @PatientId [dbo].[DPATIENT_ID] -- TG - Should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        ISNULL([int_person].[last_nm], '') + ISNULL(', ' + [int_person].[first_nm], '') AS [patient_name],
        [int_monitor].[monitor_name] AS [MONITOR_NAME],
        [int_mrn_map].[mrn_xid2] AS [ACCOUNT_ID],
        [int_mrn_map].[mrn_xid] AS [MRN_ID],
        [int_monitor].[unit_org_id] AS [UNIT_ID],
        [CHILD].[organization_cd] AS [UNIT_NAME],
        [PARENT].[organization_id] AS [FACILITY_ID],
        [PARENT].[organization_nm] AS [FACILITY_NAME],
        [int_patient].[dob] AS [DOB],
        [int_encounter].[admit_dt] AS [ADMIT_TIME],
        [int_encounter].[discharge_dt] AS [DISCHARGED_TIME],
        [int_patient_monitor].[patient_monitor_id] AS [PATIENT_MONITOR_ID],
        CASE WHEN [int_encounter].[discharge_dt] IS NULL AND ISNULL([int_monitor].[standby], 0) <> 1 THEN 'A' -- active
             WHEN [int_encounter].[discharge_dt] IS NULL AND ISNULL([int_monitor].[standby], 0) = 1  THEN 'S' -- standby
             ELSE 'D'                                                                              -- discharged
        END AS [STATUS],
        [int_patient_monitor].[last_result_dt] AS [PRECEDENCE]
    FROM
        [dbo].[int_mrn_map]
        INNER JOIN [dbo].[int_patient] ON [int_patient].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_person] ON [int_person].[person_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_encounter] ON [int_encounter].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] ON ([int_encounter].[encounter_id] = [int_patient_monitor].[encounter_id])
        INNER JOIN [dbo].[int_monitor] ON ([int_patient_monitor].[monitor_id] = [int_monitor].[monitor_id])
        INNER JOIN [dbo].[int_organization] AS [CHILD] ON ([int_monitor].[unit_org_id] = [CHILD].[organization_id])
        LEFT OUTER JOIN [dbo].[int_organization] AS [PARENT] ON [PARENT].[organization_id] = [CHILD].[parent_organization_id]
    WHERE
        [int_mrn_map].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [int_mrn_map].[merge_cd] = 'C'

    UNION

    SELECT
        [patient_name],
        [MONITOR_NAME],
        [ACCOUNT_ID],
        [MRN_ID],
        [UNIT_ID],
        [UNIT_NAME],
        [FACILITY_ID],
        [FACILITY_NAME],
        [DOB],
        --[dbo].[fnUtcDateTimeToLocalTime]([ADMIT_TIME_UTC]) AS [ADMIT_TIME],
        --[dbo].[fnUtcDateTimeToLocalTime]([DISCHARGED_TIME_UTC]) AS [DISCHARGED_TIME],
        [ADMIT_TIME].[LocalDateTime] AS [ADMIT_TIME],
        [DISCHARGED_TIME].[LocalDateTime] AS [DISCHARGED_TIME],
        [PATIENT_MONITOR_ID],
        [STATUS],
        --[dbo].[fnUtcDateTimeToLocalTime](ISNULL([DISCHARGED_TIME_UTC], GETUTCDATE())) AS [PRECEDENCE]
        ISNULL([PRECEDENCE].[LocalDateTime], GETUTCDATE()) AS [PRECEDENCE]
    FROM
        [dbo].[v_PatientSessions]
        CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([ADMIT_TIME_UTC]) AS [ADMIT_TIME]
        CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([DISCHARGED_TIME_UTC]) AS [DISCHARGED_TIME]
        CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime](ISNULL([DISCHARGED_TIME_UTC], GETUTCDATE())) AS [PRECEDENCE]
    WHERE
        [patient_id] = @PatientId
    ORDER BY
        [STATUS] ASC, [PRECEDENCE] DESC; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientData';

