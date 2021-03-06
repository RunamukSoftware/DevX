﻿CREATE PROCEDURE [dbo].[usp_InsertEncounterInformation]
    (
     @EncounterId UNIQUEIDENTIFIER,
     @OrgId UNIQUEIDENTIFIER = NULL,
     @ModDt DATETIME = NULL,
     @PatientId UNIQUEIDENTIFIER = NULL,
     @OrgPatientId UNIQUEIDENTIFIER = NULL,
     @AccountId UNIQUEIDENTIFIER = NULL,
     @StatusCd NVARCHAR(6) = NULL, -- TG - Should be NVARCHAR(3)
     @PublicityCid INT = NULL,
     @DietTypeCid INT = NULL,
     @PatientClassCid INT = NULL,
     @protectionTypeCid INT = NULL,
     @VipSw NCHAR(2) = NULL,
     @IsolationTypeCid INT = NULL,
     @SecurityTypeCid INT = NULL,
     @PatientTypeCid INT = NULL,
     @AdmitHcpId UNIQUEIDENTIFIER = NULL,
     @MedSvcCid INT = NULL,
     @ReferringHcpId UNIQUEIDENTIFIER = NULL,
     @UnitOrgId UNIQUEIDENTIFIER = NULL,
     @AttendHcpId UNIQUEIDENTIFIER = NULL,
     @PrimaryCareHcpId UNIQUEIDENTIFIER = NULL,
     @FallRiskTypeCid INT = NULL,
     @BeginDt DATETIME = NULL,
     @AmbulStatusCid INT = NULL,
     @AdmitDt DATETIME = NULL,
     @BabyCd NCHAR(2) = NULL, -- TG - Should be NCHAR(1)
     @Rm NVARCHAR(12) = NULL,
     @RecurringCd NCHAR(2) = NULL, -- TG - Should be NCHAR(1)
     @Bed NCHAR(12) = NULL,
     @Discharge_dt DATETIME = NULL,
     @NewbornSw NCHAR(2) = NULL, -- TG - Should be NCHAR(1)
     @DischargeDispoCid INT = NULL,
     @MonitorCreated TINYINT = NULL,
     @comment NVARCHAR(200) = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_encounter]
            ([encounter_id],
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
            )
    VALUES
            (@EncounterId,
             @OrgId,
             GETDATE(),
             @PatientId,
             @OrgPatientId,
             @AccountId,
             CAST(@StatusCd AS NVARCHAR(3)),
             @PublicityCid,
             @DietTypeCid,
             @PatientClassCid,
             @protectionTypeCid,
             @VipSw,
             @IsolationTypeCid,
             @SecurityTypeCid,
             @PatientTypeCid,
             @AdmitHcpId,
             @MedSvcCid,
             @ReferringHcpId,
             @UnitOrgId,
             @AttendHcpId,
             @PrimaryCareHcpId,
             @FallRiskTypeCid,
             @BeginDt,
             @AmbulStatusCid,
             @AdmitDt,
             CAST(@BabyCd AS NCHAR(1)),
             @Rm,
             CAST(@RecurringCd AS NCHAR(1)),
             @Bed,
             @Discharge_dt,
             CAST(@NewbornSw AS NCHAR(1)),
             @DischargeDispoCid,
             @MonitorCreated,
             @comment
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Encounter information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertEncounterInformation';

