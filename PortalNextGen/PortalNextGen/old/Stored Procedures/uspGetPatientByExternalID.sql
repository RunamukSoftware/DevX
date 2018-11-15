CREATE PROCEDURE [old].[uspGetPatientByExternalID] (@PatientExtID AS NVARCHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @PatientExtIDTrim NVARCHAR(30) = RTRIM(LTRIM(@PatientExtID));

        SELECT
            [imm].[PatientID],
            [imm].[MedicalRecordNumberXID],
            [ipe].[FirstName],
            [ipe].[LastName]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [Intesys].[Encounter]          AS [ie]
                    ON [ie].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]             AS [ipe]
                    ON [ie].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Patient]            AS [ipa]
                    ON [ie].[PatientID] = [ipa].[PatientID]
            INNER JOIN
                [Intesys].[PatientMonitor]     AS [ipm]
                    ON [ipm].[EncounterID] = [ie].[EncounterID]
            INNER JOIN
                [Intesys].[Monitor]            AS [im]
                    ON [im].[MonitorID] = [ipm].[MonitorID]
        WHERE
            RTRIM(LTRIM([imm].[MedicalRecordNumberXID])) = @PatientExtIDTrim
            AND [imm].[MergeCode] = 'C' -- first return patients matching ID1
        UNION ALL
        SELECT
            [vp].[PatientID],
            [vp].[ID1] AS [PatientMedicalRecordNumber],
            [vp].[FirstName],
            [vp].[LastName]
        FROM
            [old].[vwPatients] AS [vp]
        WHERE
            [vp].[ID1] = @patientExtID -- first return patients matching ID1
        UNION ALL
        SELECT
            [imm].[PatientID],
            [imm].[MedicalRecordNumberXID] AS [PatientMedicalRecordNumber],
            [ipe].[FirstName],
            [ipe].[LastName]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [Intesys].[Encounter]          AS [ie]
                    ON [ie].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]             AS [ipe]
                    ON [ie].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Patient]            AS [ipa]
                    ON [ie].[PatientID] = [ipa].[PatientID]
            INNER JOIN
                [Intesys].[PatientMonitor]     AS [ipm]
                    ON [ipm].[EncounterID] = [ie].[EncounterID]
            INNER JOIN
                [Intesys].[Monitor]            AS [im]
                    ON [im].[MonitorID] = [ipm].[MonitorID]
        WHERE
            RTRIM(LTRIM([imm].[MedicalRecordNumberXID2])) = @PatientExtIDTrim
            AND [imm].[MergeCode] = 'C' -- then return patients matching ID2
        UNION ALL
        SELECT
            [vp].[PatientID],
            [vp].[ID1] AS [PatientMedicalRecordNumber],
            [vp].[FirstName],
            [vp].[LastName]
        FROM
            [old].[vwPatients] AS [vp]
        WHERE
            [vp].[ID2] = @patientExtID; -- then return patients matching ID2
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientByExternalID';

