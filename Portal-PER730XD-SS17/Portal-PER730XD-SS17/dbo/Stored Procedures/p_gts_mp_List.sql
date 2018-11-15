CREATE PROCEDURE [dbo].[p_gts_mp_List]
AS
BEGIN
    SET DEADLOCK_PRIORITY LOW;

    SELECT
        [int_monitor].[network_id],
        [int_monitor].[node_id],
        [int_monitor].[bed_id],
        [int_monitor].[room],
        [int_monitor].[monitor_name],
        [int_monitor].[subnet],
        [dbo].[int_mrn_map].[mrn_xid],
        [dbo].[int_mrn_map].[mrn_xid2],
        [dbo].[int_mrn_map].[adt_adm_sw],
        [dbo].[int_person].[first_nm],
        [dbo].[int_person].[middle_nm],
        [dbo].[int_person].[last_nm],
        [dbo].[int_encounter].[admit_dt],
        [int_patient_monitor].[monitor_interval],
        [int_patient_monitor].[last_poll_dt],
        [int_patient_monitor].[last_result_dt],
        [int_patient_monitor].[last_episodic_dt],
        [int_patient_monitor].[last_outbound_dt],
        [int_patient_monitor].[monitor_status],
        [int_patient_monitor].[monitor_connect_dt]
    FROM
        [dbo].[int_patient_monitor]
        INNER JOIN [dbo].[int_monitor] ON [int_patient_monitor].[monitor_id] = [int_monitor].[monitor_id]
        INNER JOIN [dbo].[int_person] ON [int_patient_monitor].[patient_id] = [dbo].[int_person].[person_id]
        INNER JOIN [dbo].[int_encounter] ON [int_patient_monitor].[patient_id] = [dbo].[int_encounter].[patient_id]
        INNER JOIN [dbo].[int_mrn_map] ON [int_patient_monitor].[patient_id] = [dbo].[int_mrn_map].[patient_id]
    WHERE
        [int_patient_monitor].[active_sw] = 1
        AND [dbo].[int_mrn_map].[merge_cd] = 'C'
    ORDER BY
        [int_monitor].[node_id],
        [int_monitor].[bed_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_gts_mp_List';

