CREATE PROCEDURE [HL7].[uspUpdatePatientInformation]
    (
        @PatientID             INT,
        @BirthOrder            TINYINT,
        @VeteranStatusCodeID   INT,
        @BirthPlace            NVARCHAR(50),
        @SocialSecurityNumber  VARCHAR(15),
        @DateOfBirth           DATE,
        @DeathDate             DATE,
        @NationalityCodeID     INT,
        @CitizenshipCodeID     INT,
        @EthnicGroupCodeID     INT,
        @RaceCodeID            INT,
        @GenderCodeID          INT,
        @PrimaryLanguageCodeID INT,
        @MaritalStatusCodeID   INT,
        @ReligionCodeID        INT,
        @LivingWillSwitch      BIT,
        @OrganDonorSwitch      BIT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Patient]
        SET
            [BirthOrder] = @BirthOrder,
            [VeteranStatusCodeID] = @VeteranStatusCodeID,
            [BirthPlace] = @BirthPlace,
            [SocialSecurityNumber] = @SocialSecurityNumber,
            [DateOfBirth] = @DateOfBirth,
            [DeathDate] = @DeathDate,
            [NationalityCodeID] = @NationalityCodeID,
            [CitizenshipCodeID] = @CitizenshipCodeID,
            [EthnicGroupCodeID] = @EthnicGroupCodeID,
            [RaceCodeID] = @RaceCodeID,
            [GenderCodeID] = @GenderCodeID,
            [PrimaryLanguageCodeID] = @PrimaryLanguageCodeID,
            [MaritalStatusCodeID] = @MaritalStatusCodeID,
            [ReligionCodeID] = @ReligionCodeID,
            [OrganDonorSwitch] = @OrganDonorSwitch,
            [LivingWillSwitch] = @LivingWillSwitch
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientInformation';

