CREATE PROCEDURE [dbo].[usp_CEI_GetVitalSigns]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [int_vital_live].[patient_id],
        [int_vital_live].[collect_dt],
        [int_vital_live].[vital_value],
        [int_mrn_map].[mrn_xid],
        [int_mrn_map].[mrn_xid2],
        [int_person].[first_nm],
        [int_person].[middle_nm],
        [int_person].[last_nm],
        [int_person].[person_id],
        [int_organization].[organization_cd],
        [int_monitor].[node_id],
        [int_monitor].[monitor_name]
    FROM
        [dbo].[int_vital_live]
        INNER JOIN [dbo].[int_mrn_map] ON [int_vital_live].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_person] ON [int_vital_live].[patient_id] = [int_person].[person_id]
        INNER JOIN [dbo].[int_monitor] ON [int_vital_live].[monitor_id] = [int_monitor].[monitor_id]
        INNER JOIN [dbo].[int_patient_monitor] ON [int_vital_live].[patient_id] = [int_patient_monitor].[patient_id]
                                                  AND [int_patient_monitor].[active_sw] = 1
        INNER JOIN [dbo].[int_organization] ON [int_monitor].[unit_org_id] = [int_organization].[organization_id]
    WHERE
        [int_mrn_map].[merge_cd] = 'C';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetVitalSigns';

