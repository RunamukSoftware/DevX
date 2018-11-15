CREATE PROCEDURE [old].[uspGetLicensedPersonAndPatientDataByPatientID]
    (
        @PatientID     INT,
        @monitorID AS INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ORG].[OrganizationCode]                        AS [UNITNAME],
            [MedicalRecordNumber].[MedicalRecordNumberXID]  AS [MedicalRecordNumber],
            [ENC].[PatientTypeCodeID]                       AS [PATIENTTYPE],
            [ENC].[MedicalServiceCodeID]                    AS [HOSPSERVICE],
            [ENC].[PatientClassCodeID]                      AS [PATIENTCLASS],
            [ENC].[AmbulatoryStatusCodeID]                  AS [AMBULATORYSTS],
            [ENC].[VipSwitch]                               AS [VipIndicator],
            [ENC].[DischargeDispositionCodeID]              AS [DischargeDisposition],
            [ENC].[AdmitDateTime],
            [ENC].[DischargeDateTime],
            [ENCMAP].[EncounterXID]                         AS [VISITNUMBER],
            [ENCMAP].[SequenceNumber]                       AS [SequenceNumber],
            [MON].[MonitorName]                             AS [NODENAME],
            [MON].[NodeID]                                  AS [NODEID],
            [MON].[Room]                                    AS [Room],
            [MON].[BedCode]                                 AS [Bed],
            [PAT].[DateOfBirth],
            [PAT].[GenderCodeID]                            AS [GenderCode],
            [PAT].[RaceCodeID]                              AS [RACECD],
            [PAT].[PrimaryLanguageCodeID]                   AS [PRIMLANGCODE],
            [PAT].[MaritalStatusCodeID]                     AS [MARITALSTATUSCD],
            [PAT].[ReligionCodeID]                          AS [RELIGIONCD],
            [PAT].[SocialSecurityNumber]                    AS [SocialSecurityNumber],
            [PAT].[EthnicGroupCodeID]                       AS [ETHNICGRPCD],
            [PAT].[BirthPlace],
            [PAT].[BirthOrder],
            [PAT].[NationalityCodeID]                       AS [NATIONALITYCODE],
            [PAT].[CitizenshipCodeID]                       AS [CITIZENSHIPCODE],
            [PAT].[VeteranStatusCodeID]                     AS [VETERANSTATUSCODE],
            [PAT].[DeathDate],
            [PAT].[OrganDonorSwitch]                        AS [ORGANDONOR],
            [PAT].[LivingWillSwitch]                        AS [LIVINGWILL],
            [PERSON].[FirstName],
            [PERSON].[MiddleName],
            [PERSON].[LastName],
            [PERSON].[Suffix],
            [PERSON].[TelephoneNumber],
            [PERSON].[Line1Description]                     AS [ADDRESS1],
            [PERSON].[Line2Description]                     AS [ADDRESS2],
            [PERSON].[Line3Description]                     AS [ADDRESS3],
            [PERSON].[City]                                 AS [CITY],
            [PERSON].[StateCode],
            [PERSON].[ZipCode],
            [PERSON].[CountryCodeID]                        AS [COUNTRYCODE],
            [MedicalRecordNumber].[MedicalRecordNumberXID2] AS [ACCOUNTNUMBER]
        FROM
            [Intesys].[Encounter]                  AS [ENC]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [MedicalRecordNumber]
                    ON [ENC].[PatientID] = [MedicalRecordNumber].[PatientID]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [PATMON]
                    ON [MedicalRecordNumber].[PatientID] = [PATMON].[PatientID]
            INNER JOIN
                [Intesys].[Monitor]                AS [MON]
                    ON [PATMON].[MonitorID] = [MON].[MonitorID]
            INNER JOIN
                [Intesys].[EncounterMap]           AS [ENCMAP]
                    ON [PATMON].[EncounterID] = [ENCMAP].[EncounterID]
            INNER JOIN
                [Intesys].[Organization]           AS [ORG]
                    ON [MON].[UnitOrganizationID] = [ORG].[OrganizationID]
            INNER JOIN
                [Intesys].[ProductAccess]          AS [ACCESS]
                    ON [ORG].[OrganizationID] = [ACCESS].[OrganizationID]
            INNER JOIN
                [Intesys].[Patient]                AS [PAT]
                    ON [ENC].[PatientID] = [PAT].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [PERSON]
                    ON [PAT].[PatientID] = [PERSON].[PersonID]
        WHERE
            ([MedicalRecordNumber].[PatientID] = @PatientID)
            AND [MON].[MonitorID] = @monitorID
            --AND (patMon.ActiveSwitch = 1) 
            AND [ORG].[OutboundInterval] > 0
            AND [ACCESS].[ProductCode] = 'outHL7'
            AND [ORG].[CategoryCode] = 'D'
            AND (
                    [ENC].[DischargeDateTime] IS NULL
                    OR [ENC].[DischargeDateTime] > [ENC].[AdmitDateTime]
                )
            AND ([MedicalRecordNumber].[MergeCode] = 'C')
        ORDER BY
            [ENC].[AdmitDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DM3...', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLicensedPersonAndPatientDataByPatientID';

