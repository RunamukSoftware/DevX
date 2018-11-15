CREATE PROCEDURE [dbo].[usp_HL7_UpdatePatientVisitInformation]
    (
     @EncounterId UNIQUEIDENTIFIER,
     @ModDt DATETIME = NULL,
     @AccountId UNIQUEIDENTIFIER = NULL,
     @StatusCd NVARCHAR(3),
     @PatientClassCid INT = NULL,
     @VipSw NCHAR(1) = NULL,
     @PatientTypeCid INT = NULL,
     @UnitOrgId UNIQUEIDENTIFIER,
     @AdmitDt DATETIME = NULL,
     @Rm NVARCHAR(80) = NULL,
     @Bed NVARCHAR(80) = NULL,
     @DischargeDt DATETIME = NULL,
     @MessageDateTime DATETIME = NULL
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
        [status_cd] = @StatusCd,
        [vip_sw] = @VipSw,
        [patient_type_cid] = @PatientTypeCid,
        [patient_class_cid] = @PatientClassCid,
        [unit_org_id] = @UnitOrgId,
        [admit_dt] = @AdmitDt,
        [rm] = @Rm,
        [bed] = @Bed,
        [begin_dt] = @MessageDateTime,
        [discharge_dt] = @DischargeDt
    WHERE
        [encounter_id] = @EncounterId;

    UPDATE
        [dbo].[int_encounter_map]
    SET
        [account_id] = @AccountId
    WHERE
        [encounter_id] = @EncounterId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the patients Visit Information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdatePatientVisitInformation';

