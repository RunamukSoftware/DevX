CREATE PROCEDURE [HL7].[uspGetPersonAndPatientDataByPatientID] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [Pat].[DateOfBirth]             AS [DateOfBirth],
            [Pat].[GenderCodeID]            AS [GenderCode],
            [Pat].[RaceCodeID]              AS [RaceCode],
            [Pat].[PrimaryLanguageCodeID]   AS [PrimLangCode],
            [Pat].[MaritalStatusCodeID]     AS [MaritalStatusCode],
            [Pat].[ReligionCodeID]          AS [ReligionCode],
            [Pat].[SocialSecurityNumber],
            [Pat].[EthnicGroupCodeID]       AS [EthnicGrpCode],
            [Pat].[BirthPlace],
            [Pat].[BirthOrder],
            [Pat].[NationalityCodeID]       AS [NationalityCode],
            [Pat].[CitizenshipCodeID]       AS [CitizenshipCode],
            [Pat].[VeteranStatusCodeID]     AS [VeteranStatusCode],
            [Pat].[DeathDate],
            [Pat].[OrganDonorSwitch]        AS [OrganDonor],
            [Pat].[LivingWillSwitch]        AS [LivingWill],
            [person].[FirstName]            AS [FirstName],
            [person].[MiddleName]           AS [MiddleName],
            [person].[LastName]             AS [LastName],
            [person].[Suffix]               AS [Suffix],
            [person].[TelephoneNumber]      AS [Telephone],
            [person].[Line1Description]            AS [Address1],
            [person].[Line2Description]            AS [Address2],
            [person].[Line3Description]            AS [Address3],
            [person].[City]              AS [City],
            [person].[StateCode]            AS [StateCode],
            [person].[ZipCode]              AS [Zip],
            [person].[CountryCodeID]        AS [CountryCode],
            [imm].[MedicalRecordNumberXID2] AS [AccountNumber],
            [imm].[MedicalRecordNumberXID]  AS [MedicalRecordNumber]
        FROM
            [Intesys].[Patient]                    AS [Pat]
            INNER JOIN
                [Intesys].[Person]                 AS [person]
                    ON [Pat].[PatientID] = [person].[PersonID]
                       AND [Pat].[PatientID] = @PatientID
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [Pat].[PatientID] = [imm].[PatientID]
        WHERE
            [imm].[MergeCode] = 'C'
        UNION
        SELECT
            NULL                    AS [DateOfBirth],
            NULL                    AS [GenderCode],
            NULL                    AS [RaceCode],
            NULL                    AS [PrimLangCode],
            NULL                    AS [MaritalStatusCode],
            NULL                    AS [ReligionCode],
            NULL                    AS [SocialSecurityNumber],
            --NULL AS [DLNo],
            --NULL AS [DLStateCode],
            NULL                    AS [EthnicGrpCode],
            NULL                    AS [BirthPlace],
            NULL                    AS [BirthOrder],
            NULL                    AS [NationalityCode],
            NULL                    AS [CitizenshipCode],
            NULL                    AS [VeteranStatusCode],
            NULL                    AS [DeathDate],
            NULL                    AS [OrganDonor],
            NULL                    AS [LivingWill],
            [FirstName],
            [MiddleName],
            [LastName],
            NULL                    AS [Suffix],
            NULL                    AS [Telephone],
            NULL                    AS [Address1],
            NULL                    AS [Address2],
            NULL                    AS [Address3],
            NULL                    AS [City],
            NULL                    AS [StateCode],
            NULL                    AS [Zip],
            NULL                    AS [CountryCode],
            [AccountID]             AS [AccountNumber],
            [MedicalRecordNumberID] AS [MedicalRecordNumber]
        FROM
            [old].[vwPatientSessions]
        WHERE
            [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient details by patient id.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetPersonAndPatientDataByPatientID';

