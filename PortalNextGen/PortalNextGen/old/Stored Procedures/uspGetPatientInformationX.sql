CREATE PROCEDURE [old].[uspGetPatientInformationX]
    (
        @PatientID      INT = NULL,
        @OrganizationID INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imm].[PatientID],
            [ipe].[LastName],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [imm].[MedicalRecordNumberXID],
            [imm].[MedicalRecordNumberXID2],
            [imm].[OrganizationID],
            [ipa].[DateOfBirth],
            [ipa].[GenderCodeID],
            [imc].[Code],
            [ipa].[Height],
            [ipa].[Weight],
            [ipa].[BodySurfaceArea],
            [imm].[AdmitDischargeTransferAdmitSwitch]
        FROM
            (
                SELECT
                    @PatientID      AS [ID1],
                    @OrganizationID AS [OrgID]
            )                                      AS [WantedPatient]
            LEFT OUTER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [WantedPatient].[ID1] = [imm].[MedicalRecordNumberXID]
                       AND [WantedPatient].[OrgID] = [imm].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [imm].[PatientID] = [ipe].[PersonID]
            LEFT OUTER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [imc].[CodeID] = [ipa].[GenderCodeID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient demographics in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientInformationX';

