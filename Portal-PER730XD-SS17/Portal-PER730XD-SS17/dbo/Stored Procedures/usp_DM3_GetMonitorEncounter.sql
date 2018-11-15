CREATE PROCEDURE [dbo].[usp_DM3_GetMonitorEncounter]
    (
     @PatientGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @ConnectionDate NVARCHAR(50) = NULL -- TG - should be DATETIME
    )
AS
BEGIN
    SELECT
        [encounter_id],
        [organization_id],
        [mod_dt],
        [patient_id],
        [orig_patient_id],
        [account_id],
        [status_cd],
        [publicity_cid],
        [diet_type_cid],
        [patient_class_cid],
        [protection_type_cid],
        [vip_sw],
        [isolation_type_cid],
        [security_type_cid],
        [patient_type_cid],
        [admit_hcp_id],
        [med_svc_cid],
        [referring_hcp_id],
        [unit_org_id],
        [attend_hcp_id],
        [primary_care_hcp_id],
        [fall_risk_type_cid],
        [begin_dt],
        [ambul_status_cid],
        [admit_dt],
        [baby_cd],
        [rm],
        [recurring_cd],
        [bed],
        [discharge_dt],
        [newborn_sw],
        [discharge_dispo_cid],
        [monitor_created],
        [comment]
    FROM
        [dbo].[int_encounter]
    WHERE
        [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
        AND [admit_dt] = CAST(@ConnectionDate AS DATETIME)
        AND [monitor_created] = 1
    ORDER BY
        [discharge_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetMonitorEncounter';

