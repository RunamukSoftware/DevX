CREATE PROCEDURE [dbo].[GetPatientByExternalID]
    (
     @patientExtID AS NVARCHAR(30)
    )
AS
BEGIN
    DECLARE @patientExtIDTrim NVARCHAR(30) = RTRIM(LTRIM(@patientExtID));

    SELECT
        [int_mrn_map].[patient_id] AS [patient_id],
        [int_mrn_map].[mrn_xid] AS [PATIENT_MRN],
        [int_person].[first_nm] AS [FIRST_NAME],
        [int_person].[last_nm] AS [LAST_NAME]
    FROM
        [dbo].[int_mrn_map]
        INNER JOIN [dbo].[int_encounter] ON [int_encounter].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_person] ON [int_encounter].[patient_id] = [int_person].[person_id]
        INNER JOIN [dbo].[int_patient] ON [int_encounter].[patient_id] = [int_patient].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] ON [int_patient_monitor].[encounter_id] = [int_encounter].[encounter_id]
        INNER JOIN [dbo].[int_monitor] ON [int_monitor].[monitor_id] = [int_patient_monitor].[monitor_id]
    WHERE
        RTRIM(LTRIM([int_mrn_map].[mrn_xid])) = @patientExtIDTrim
        AND [int_mrn_map].[merge_cd] = 'C' -- first return patients matching ID1
    UNION ALL
    SELECT
        [patient_id],
        [ID1] AS [PATIENT_MRN],
        [FIRST_NAME],
        [LAST_NAME]
    FROM
        [dbo].[v_Patients]
    WHERE
        [ID1] = @patientExtID -- first return patients matching ID1
    UNION ALL
    SELECT
        [int_mrn_map].[patient_id] AS [patient_id],
        [int_mrn_map].[mrn_xid] AS [PATIENT_MRN],
        [int_person].[first_nm] AS [FIRST_NAME],
        [int_person].[last_nm] AS [LAST_NAME]
    FROM
        [dbo].[int_mrn_map]
        INNER JOIN [dbo].[int_encounter] ON [int_encounter].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_person] ON [int_encounter].[patient_id] = [int_person].[person_id]
        INNER JOIN [dbo].[int_patient] ON [int_encounter].[patient_id] = [int_patient].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] ON [int_patient_monitor].[encounter_id] = [int_encounter].[encounter_id]
        INNER JOIN [dbo].[int_monitor] ON [int_monitor].[monitor_id] = [int_patient_monitor].[monitor_id]
    WHERE
        RTRIM(LTRIM([int_mrn_map].[mrn_xid2])) = @patientExtIDTrim
        AND [int_mrn_map].[merge_cd] = 'C' -- then return patients matching ID2
    UNION ALL
    SELECT
        [patient_id],
        [ID1] AS [PATIENT_MRN],
        [FIRST_NAME],
        [LAST_NAME]
    FROM
        [dbo].[v_Patients]
    WHERE
        [ID2] = @patientExtID; -- then return patients matching ID2
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientByExternalID';

