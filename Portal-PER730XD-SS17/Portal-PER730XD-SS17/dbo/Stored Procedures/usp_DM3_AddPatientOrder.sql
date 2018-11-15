CREATE PROCEDURE [dbo].[usp_DM3_AddPatientOrder]
    (
     @OrderIDGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @PatientGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @Result_usid NVARCHAR(50) = NULL, -- TG - should be INT
     @EncounterGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @MainOrgGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @SendSysID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @Guid15 NVARCHAR(50) = NULL -- TG - should be NVARCHAR(30)
    )
AS
BEGIN
--BEGIN TRANSACTION
    INSERT  INTO [dbo].[int_order_line]
            ([order_id],
             [seq_no],
             [patient_id],
             [orig_patient_id],
             [status_cid],
             [prov_svc_cid],
             [univ_svc_cid],
             [transport_cid],
             [order_line_comment],
             [clin_info_comment],
             [reason_comment],
             [scheduled_dt],
             [observ_dt],
             [status_chg_dt]
            )
    VALUES
            (CAST(@OrderIDGUID AS UNIQUEIDENTIFIER),
             1,
             CAST(@PatientGUID AS UNIQUEIDENTIFIER),
             NULL,
             NULL,
             NULL,
             CAST(@Result_usid AS INT),
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL
            );

    INSERT  INTO [dbo].[int_order]
            ([encounter_id],
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
            )
    VALUES
            (CAST(@EncounterGUID AS UNIQUEIDENTIFIER),
             CAST(@OrderIDGUID AS UNIQUEIDENTIFIER),
             CAST(@PatientGUID AS UNIQUEIDENTIFIER),
             NULL,
             NULL,
             NULL,
             CAST(@Result_usid AS INT),
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             CAST(0 AS TINYINT),
             NULL,
             CAST(0 AS TINYINT),
             CAST(1 AS TINYINT)
            );

    INSERT  INTO [dbo].[int_order_map]
            ([order_id],
             [patient_id],
             [orig_patient_id],
             [organization_id],
             [sys_id],
             [order_xid],
             [type_cd],
             [seq_no]
            )
    VALUES
            (CAST(@OrderIDGUID AS UNIQUEIDENTIFIER),
             CAST(@PatientGUID AS UNIQUEIDENTIFIER),
             NULL,
             CAST(@MainOrgGUID AS UNIQUEIDENTIFIER),
             CAST(@SendSysID AS UNIQUEIDENTIFIER),
             CAST(@Guid15 AS NVARCHAR(30)),
             'F',
             CAST(1 AS INT)
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_AddPatientOrder';

