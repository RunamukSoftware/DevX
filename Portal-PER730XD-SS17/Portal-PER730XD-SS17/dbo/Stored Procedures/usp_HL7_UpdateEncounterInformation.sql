CREATE PROCEDURE [dbo].[usp_HL7_UpdateEncounterInformation]
    (
     @EncounterId UNIQUEIDENTIFIER,
     @ModDt DATETIME = NULL,
     @AccountId UNIQUEIDENTIFIER,
     @StatusCd NVARCHAR(6), -- TG - should be NVARCHAR(3)
     @PatientClassCid INT,
     @VipSw NCHAR(2),
     @PatientTypeCid INT,
     @MedSvcCid INT,
     @UnitOrgId UNIQUEIDENTIFIER,
     @BeginDt DATETIME,
     @AmbulStatusCid INT,
     @AdmitDt DATETIME,
     @Rm NVARCHAR(12),
     @Bed NCHAR(12),
     @DischargeDt DATETIME,
     @DischargeDispoCid INT
    )
AS
BEGIN
    IF @ModDt IS NULL
        SET @ModDt = GETDATE();

    UPDATE
        [dbo].[int_encounter]
    SET
        [account_id] = @AccountId,
        [mod_dt] = @ModDt,
        [status_cd] = CAST(@StatusCd AS NVARCHAR(3)),
        [patient_class_cid] = @PatientClassCid,
        [vip_sw] = @VipSw,
        [patient_type_cid] = @PatientTypeCid,
        [med_svc_cid] = @MedSvcCid,
        [unit_org_id] = @UnitOrgId,
        [begin_dt] = @BeginDt,
        [ambul_status_cid] = @AmbulStatusCid,
        [admit_dt] = @AdmitDt,
        [rm] = @Rm,
        [bed] = @Bed,
        [discharge_dt] = @DischargeDt,
        [discharge_dispo_cid] = @DischargeDispoCid
    WHERE
        [encounter_id] = @EncounterId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdateEncounterInformation';

