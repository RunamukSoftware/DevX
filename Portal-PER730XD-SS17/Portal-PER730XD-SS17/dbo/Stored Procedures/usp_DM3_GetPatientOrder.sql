CREATE PROCEDURE [dbo].[usp_DM3_GetPatientOrder]
    (
     @EncounterGUID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @Result_USID NVARCHAR(50) = NULL -- TG - should be INT
    )
AS
BEGIN
    SELECT
        [encounter_id],
        [order_id],
        [patient_id],
        [orig_patient_id],
        [priority_cid],
        [status_cid],
        [univ_svc_cid],
        [order_person_id],
        [order_dt],
        [enter_id],
        [verif_id],
        [transcriber_id],
        [parent_order_id],
        [child_order_sw],
        [order_cntl_cid],
        [history_sw],
        [monitor_sw]
    FROM
        [dbo].[int_order]
    WHERE
        [encounter_id] = CAST(@EncounterGUID AS UNIQUEIDENTIFIER)
        AND [univ_svc_cid] = cast(@Result_USID as int);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetPatientOrder';

