CREATE VIEW [old].[vwDevicePatientIdActive]
WITH SCHEMABINDING
AS
    SELECT DISTINCT
        [latest].[DeviceID],
        [imm].[MedicalRecordNumberXID] AS [ID1],
        [LatestPatientSessionsMap].[PatientID]
    FROM
        [old].[PatientSession]                 AS [ps]
        INNER JOIN
            (
                SELECT
                    [PatientAssignmentSequence].[PatientSessionID],
                    [PatientAssignmentSequence].[DeviceID]
                FROM
                    (
                        SELECT
                            [pd].[PatientSessionID],
                            [ds].[DeviceID],
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [pd].[PatientSessionID]
                                               ORDER BY
                                                   [pd].[Timestamp] DESC
                                              ) AS [RowNumber]
                        FROM
                            [old].[Patient]       AS [pd]
                            INNER JOIN
                                [old].[DeviceSession] AS [ds]
                                    ON [ds].[EndDateTime] IS NULL
                                       AND [ds].[DeviceSessionID] = [pd].[DeviceSessionID]
                    ) AS [PatientAssignmentSequence]
                WHERE
                    [PatientAssignmentSequence].[RowNumber] = 1
            )                                  AS [latest]
                ON [latest].[PatientSessionID] = [ps].[PatientSessionID]
        INNER JOIN
            (
                SELECT
                    [PatientSessionsMapSequence].[PatientSessionID],
                    [PatientSessionsMapSequence].[PatientID]
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
                    ) AS [PatientSessionsMapSequence]
                WHERE
                    [PatientSessionsMapSequence].[RowNumber] = 1
            )                                  AS [LatestPatientSessionsMap]
                ON [LatestPatientSessionsMap].[PatientSessionID] = [ps].[PatientSessionID]
        INNER JOIN
            [Intesys].[MedicalRecordNumberMap] AS [imm]
                ON [imm].[PatientID] = [LatestPatientSessionsMap].[PatientID]
                   AND [imm].[MergeCode] = 'C';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDevicePatientIdActive';

