CREATE PROCEDURE [old].[uspInsertPatientInformation]
    (
        @PatientID             INT,
        @NewPatientID          INT          = NULL,
        @OrganDonorSwitch      BIT,
        @LivingWillSwitch      BIT,
        @BirthOrder            TINYINT      = NULL,
        @VeteranStatusCodeID   INT          = NULL,
        @BirthPlace            NVARCHAR(50) = NULL,
        @SocialSecurityNumber  VARCHAR(15) = NULL,
        @MpiSsn1               INT          = NULL,
        @MpiSsn2               INT          = NULL,
        @MpiSsn3               INT          = NULL,
        @MpiSsn4               INT          = NULL,
        @DrivLicNo             NVARCHAR(50) = NULL,
        @MpiDl1                NVARCHAR(3)  = NULL,
        @MpiDl2                NVARCHAR(3)  = NULL,
        @MpiDl3                NVARCHAR(3)  = NULL,
        @MpiDl4                NVARCHAR(3)  = NULL,
        @DrivLicStateCode      NVARCHAR(3)  = NULL,
        @DateOfBirth           DATE         = NULL,
        @DeathDate             DATE         = NULL,
        @NationalityCodeID     INT          = NULL,
        @CitizenshipCodeID     INT          = NULL,
        @EthnicGroupCodeID     INT          = NULL,
        @RaceCodeID            INT          = NULL,
        @GenderCodeID          INT          = NULL,
        @PrimaryLanguageCodeID INT          = NULL,
        @MaritalStatusCodeID   INT          = NULL,
        @ReligionCodeID        INT          = NULL,
        @MonitorInterval       INT          = NULL,
        @Height                FLOAT        = NULL,
        @Weight                FLOAT        = NULL,
        @Bsa                   FLOAT        = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Patient]
            (
                [PatientID],
                [NewPatientID],
                [OrganDonorSwitch],
                [LivingWillSwitch],
                [BirthOrder],
                [VeteranStatusCodeID],
                [BirthPlace],
                [SocialSecurityNumber],
                [MpiSocialSecurityNumber1],
                [MpiSocialSecurityNumber2],
                [MpiSocialSecurityNumber3],
                [MpiSocialSecurityNumber4],
                [MpiDriversLicenseNumber1],
                [MpiDriversLicenseNumber2],
                [MpiDriversLicenseNumber3],
                [MpiDriversLicenseNumber4],
                [DateOfBirth],
                [DeathDate],
                [NationalityCodeID],
                [CitizenshipCodeID],
                [EthnicGroupCodeID],
                [RaceCodeID],
                [GenderCodeID],
                [PrimaryLanguageCodeID],
                [MaritalStatusCodeID],
                [ReligionCodeID],
                [MonitorInterval],
                [Height],
                [Weight],
                [BodySurfaceArea]
            )
        VALUES
            (
                @PatientID, @NewPatientID, @OrganDonorSwitch, @LivingWillSwitch, @BirthOrder, @VeteranStatusCodeID,
                @BirthPlace, @SocialSecurityNumber, @MpiSsn1, @MpiSsn2, @MpiSsn3, @MpiSsn4, @MpiDl1, @MpiDl2, @MpiDl3,
                @MpiDl4, @DateOfBirth, @DeathDate, @NationalityCodeID, @CitizenshipCodeID, @EthnicGroupCodeID,
                @RaceCodeID, @GenderCodeID, @PrimaryLanguageCodeID, @MaritalStatusCodeID, @ReligionCodeID,
                @MonitorInterval, @Height, @Weight, @Bsa
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the patient Information from any component.  @PatientID is mandatory and the remaining are optional with default NULL values.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertPatientInformation';

