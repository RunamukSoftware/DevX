CREATE PROCEDURE [DM3].[uspGetPatientInformation]
    (
        @MedicalRecordNumberXID NVARCHAR(30) = NULL,
        @OrganizationID         INT          = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipa].[PatientID],
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
            [Intesys].[Patient]                    AS [ipa]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipa].[PatientID] = [ipe].[PersonID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [ipa].[GenderCodeID] = [imc].[CodeID]
        WHERE
            [imm].[MedicalRecordNumberXID] = @MedicalRecordNumberXID
            AND [imm].[OrganizationID] = @OrganizationID
            AND [imm].[MergeCode] = 'C';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientInformation';

