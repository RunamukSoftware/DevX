CREATE PROCEDURE [old].[uspGetPatientInfo] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imm].[MedicalRecordNumberXID],
            [imm].[MedicalRecordNumberXID2],
            [ipe].[LastName],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [ipa].[DateOfBirth],
            [imc].[ShortDescription],
            [ipa].[Height],
            [ipa].[Weight],
            [ipa].[BodySurfaceArea],
            [org1].[OrganizationCode] + N' - ' + [org2].[OrganizationCode] AS [Unit],
            [ie].[Room],
            [ie].[Bed],
            [iem].[EncounterXID],
            CAST(0 AS TINYINT)                                             AS [IsDataLoader],
            [ipm].[LastResultDateTime]                                     AS [Precedence]
        FROM
            [Intesys].[Encounter]                  AS [ie]
            LEFT OUTER JOIN
                [Intesys].[Organization]           AS [org1]
                    ON [ie].[OrganizationID] = [org1].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[PatientMonitor] AS [ipm]
                INNER JOIN
                    [Intesys].[Monitor]    AS [im]
                        ON [ipm].[MonitorID] = [im].[MonitorID]
                    ON [ie].[EncounterID] = [ipm].[EncounterID]
                       AND [ie].[PatientID] = [ipm].[PatientID]
            INNER JOIN
                [Intesys].[EncounterMap]           AS [iem]
                    ON [ie].[EncounterID] = [iem].[EncounterID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ie].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipe].[PersonID] = [ipa].[PatientID]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Organization]           AS [org2]
                    ON [ie].[UnitOrganizationID] = [org2].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [ipa].[GenderCodeID] = [imc].[CodeID]
        WHERE
            [imm].[MergeCode] = 'C'
            AND [imm].[PatientID] = @PatientID
        UNION
        SELECT
            [imm].[MedicalRecordNumberXID],
            [imm].[MedicalRecordNumberXID2],
            [ipe].[LastName],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [ipa].[DateOfBirth],
            [imc].[ShortDescription],
            [ipa].[Height],
            [ipa].[Weight],
            [ipa].[BodySurfaceArea],
            [Facilities].[OrganizationCode] + N' - ' + [Units].[OrganizationCode] AS [Unit],
            [d].[Room]                                                            AS [Room],
            [Assignment].[BedName]                                                AS [Bed],
            CAST(NULL AS NVARCHAR(40))                                            AS [EncounterXID],
            CAST(1 AS TINYINT)                                                    AS [IsDataLoader],
            [ps].[BeginDateTime]                                                  AS [Precedence]
        FROM
            [old].[PatientSession]                 AS [ps] -- From the patient session, get to the patient
            INNER JOIN
                (
                    SELECT
                        [PatientSessionsAssignmentSequence].[PatientSessionID],
                        [PatientSessionsAssignmentSequence].[PatientID]
                    FROM
                        (
                            SELECT
                                [psm].[PatientSessionID],
                                [psm].[PatientID],
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [psm].[PatientSessionID]
                                                   ORDER BY
                                                       [psm].[PatientSessionMapID] DESC
                                                  ) AS [RowNumber]
                            FROM
                                [old].[PatientSessionMap] AS [psm]
                        ) AS [PatientSessionsAssignmentSequence]
                    WHERE
                        [PatientSessionsAssignmentSequence].[RowNumber] = 1
                )                                  AS [LatestPatientSessionAssignment]
                    ON [LatestPatientSessionAssignment].[PatientSessionID] = [ps].[PatientSessionID]

            -- From the patient session, get to the device and ID1
            INNER JOIN
                (
                    SELECT
                        [PatientSessionsDeviceSequence].[PatientSessionID],
                        [PatientSessionsDeviceSequence].[DeviceSessionID]
                    FROM
                        (
                            SELECT
                                [pd].[PatientSessionID],
                                [pd].[DeviceSessionID],
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [pd].[PatientSessionID]
                                                   ORDER BY
                                                       [pd].[Timestamp] DESC
                                                  ) AS [RowNumber]
                            FROM
                                [old].[Patient] AS [pd]
                        ) AS [PatientSessionsDeviceSequence]
                    WHERE
                        [PatientSessionsDeviceSequence].[RowNumber] = 1
                )                                  AS [LatestPatientSessionDevice]
                    ON [LatestPatientSessionDevice].[PatientSessionID] = [ps].[PatientSessionID]
            INNER JOIN
                [old].[DeviceSession]              AS [ds]
                    ON [ds].[DeviceSessionID] = [LatestPatientSessionDevice].[DeviceSessionID]
            INNER JOIN
                [old].[Device]                     AS [d]
                    ON [ds].[DeviceID] = [d].[DeviceID]

            -- From the device, get to the facility and units
            INNER JOIN
                [old].[vwDeviceSessionAssignment]  AS [Assignment]
                    ON [Assignment].[DeviceSessionID] = [LatestPatientSessionDevice].[DeviceSessionID]
            LEFT OUTER JOIN
                [Intesys].[Organization]           AS [Facilities]
                    ON [Facilities].[OrganizationName] = [Assignment].[FacilityName]
                       AND [Facilities].[CategoryCode] = 'F'
            LEFT OUTER JOIN
                [Intesys].[Organization]           AS [Units]
                    ON [Units].[OrganizationName] = [Assignment].[UnitName]
                       AND [Units].[ParentOrganizationID] = [Facilities].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [imm].[PatientID] = [LatestPatientSessionAssignment].[PatientID]
                       AND [imm].[MergeCode] = 'C'
            LEFT OUTER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [LatestPatientSessionAssignment].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [LatestPatientSessionAssignment].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [imc]
                    ON [imc].[CodeID] = [ipa].[GenderCodeID]
        WHERE
            [LatestPatientSessionAssignment].[PatientID] = @PatientID
        ORDER BY
            [Precedence] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inline queries to SPs/ICS Admin Component.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientInfo';

