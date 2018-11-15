CREATE PROCEDURE [dbo].[usp_HL7_UpdatePatientInformation]
    (
     @PatientId UNIQUEIDENTIFIER,
     @BirthOrder TINYINT,
     @VeteranStatusCid INT,
     @BirthPlace NVARCHAR(100), -- TG - Should be NVARCHAR(50)
     @Ssn NVARCHAR(30), -- TG - Should be NVARCHAR(15)
     @DrivLicNo NVARCHAR(50), -- TG - Should be NVARCHAR(25)
     @DrivLicStateCode NVARCHAR(6), -- TG - Should be NVARCHAR(3)
     @dob NVARCHAR(50), -- TG - Should be DATETIME
     @deathdt NVARCHAR(50), -- TG - Should be DATETIME
     @NationalityCid INT,
     @CitizenshipCid INT,
     @EthnicGroupCid INT,
     @RaceCid INT,
     @GenderCid INT,
     @PrimaryLanguageCid INT,
     @MaritalStatusCid INT,
     @ReligionCid INT,
     @LivingWillSw NCHAR(4) = NULL,
     @OrganDonorSw NCHAR(4) = NULL
    )
AS
BEGIN
    UPDATE
        [dbo].[int_patient]
    SET
        [birth_order] = @BirthOrder,
        [veteran_status_cid] = @VeteranStatusCid,
        [birth_place] = CAST(@BirthPlace AS NVARCHAR(50)),
        [ssn] = CAST(@Ssn AS NVARCHAR(15)),
        [driv_lic_no] = CAST(@DrivLicNo AS NVARCHAR(25)),
        [driv_lic_state_code] = CAST(@DrivLicStateCode AS NVARCHAR(3)),
        [dob] = CAST(@dob AS DATETIME),
        [death_dt] = CAST(@deathdt AS DATETIME),
        [nationality_cid] = @NationalityCid,
        [citizenship_cid] = @CitizenshipCid,
        [ethnic_group_cid] = @EthnicGroupCid,
        [race_cid] = @RaceCid,
        [gender_cid] = @GenderCid,
        [primary_language_cid] = @PrimaryLanguageCid,
        [marital_status_cid] = @MaritalStatusCid,
        [religion_cid] = @ReligionCid,
        [organ_donor_sw] = ISNULL(@OrganDonorSw, [organ_donor_sw]),
        [living_will_sw] = ISNULL(@LivingWillSw, [living_will_sw])
    WHERE
        [patient_id] = @PatientId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdatePatientInformation';

