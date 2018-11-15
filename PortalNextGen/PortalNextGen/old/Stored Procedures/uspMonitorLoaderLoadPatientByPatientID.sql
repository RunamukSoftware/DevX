CREATE PROCEDURE [old].[uspMonitorLoaderLoadPatientByPatientID] (@PatientID INT)
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
            [ipa].[BodySurfaceArea]
        FROM
            [Intesys].[Patient]                    AS [ipa]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [ipa].[GenderCodeID] = [imc].[CodeID]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ipa].[PatientID] = [imm].[PatientID]
                       AND [imm].[MergeCode] = 'C'
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipa].[PatientID] = [ipe].[PersonID]
        WHERE
            [imm].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspMonitorLoaderLoadPatientByPatientID';

