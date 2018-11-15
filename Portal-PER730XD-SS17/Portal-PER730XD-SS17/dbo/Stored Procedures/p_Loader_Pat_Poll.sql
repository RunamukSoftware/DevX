CREATE PROCEDURE [dbo].[p_Loader_Pat_Poll]
    (
     @org_id UNIQUEIDENTIFIER,
     @network_id VARCHAR(50) -- TG - should be NVARCHAR(50)
    )
AS
BEGIN
    SELECT
        [MM].[mrn_xid],
        [MM].[mrn_xid2],
        [PAT].[patient_id],
        [PAT].[dob],
        [PAT].[gender_cid],
        [PAT].[height],
        [PAT].[weight],
        [PAT].[bsa],
        [PER].[last_nm],
        [PER].[first_nm],
        [PER].[middle_nm],
        [PM].[patient_monitor_id],
        [PM].[monitor_interval],
        [PM].[monitor_connect_dt],
        [PM].[last_poll_dt],
        [PM].[last_result_dt],
        [PM].[last_episodic_dt],
        [PM].[poll_start_dt],
        [PM].[poll_end_dt],
        [PM].[monitor_status],
        [PM].[monitor_error],
        [PM].[encounter_id],
        [PM].[live_until_dt],
        [MON].[network_id],
        [MON].[monitor_id],
        [MON].[monitor_name],
        [MON].[node_id],
        [MON].[bed_id],
        [MON].[room],
        [MON].[monitor_type_cd],
        [MON].[unit_org_id],
        [ORG].[outbound_interval],
        [ORG].[organization_cd]
    FROM
        [dbo].[int_mrn_map] AS [MM]
        INNER JOIN [dbo].[int_patient] AS [PAT] ON [MM].[patient_id] = [PAT].[patient_id]
        INNER JOIN [dbo].[int_person] AS [PER] ON [PAT].[patient_id] = [PER].[person_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [PM] ON [PAT].[patient_id] = [PM].[patient_id]
        INNER JOIN [dbo].[int_monitor] AS [MON] ON [PM].[monitor_id] = [MON].[monitor_id]
        INNER JOIN [dbo].[int_encounter] AS [ENC] ON [PM].[encounter_id] = [ENC].[encounter_id]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [MON].[unit_org_id] = [ORG].[organization_id]
    WHERE
        [MM].[merge_cd] = 'C'
        AND [ENC].[discharge_dt] IS NULL
        AND [MM].[organization_id] = @org_id
        AND [MON].[network_id] = CAST(@network_id AS NVARCHAR(50))
        AND [PM].[active_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Loader_Pat_Poll';

