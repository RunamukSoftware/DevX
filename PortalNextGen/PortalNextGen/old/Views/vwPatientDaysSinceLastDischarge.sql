CREATE VIEW [old].[vwPatientDaysSinceLastDischarge]
AS
    SELECT
        [CombinedView].[PatientID],
        MIN([CombinedView].[DaysSinceLastDischarge]) AS [DaysSinceLastDischarge]
    FROM
        (
            SELECT
                [e].[PatientID]                                                                         AS [PatientID],
                MIN(DATEDIFF(DAY, ISNULL([e].[DischargeDateTime], SYSUTCDATETIME()), SYSUTCDATETIME())) AS [DaysSinceLastDischarge]
            FROM
                [Intesys].[Encounter] AS [e]
            GROUP BY
                [PatientID]
            UNION ALL
            SELECT
                [LatestPatientSessionAssignment].[PatientID],
                MIN(DATEDIFF(DAY, ISNULL([ps].[EndDateTime], GETUTCDATE()), GETUTCDATE())) AS [DaysSinceLastDischarge]
            FROM
                [old].[PatientSession] AS [ps]
                INNER JOIN
                    (
                        SELECT
                            [PatientSessionAssignmentSequence].[PatientSessionID],
                            [PatientSessionAssignmentSequence].[PatientID]
                        FROM
                            (
                                SELECT
                                    [psm].[PatientSessionID],
                                    [psm].[PatientID],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [psm].[PatientSessionID]
                                                       ORDER BY
                                                           [psm].[PatientSessionMapID] DESC
                                                      ) AS [r]
                                FROM
                                    [old].[PatientSessionMap] AS [psm]
                            ) AS [PatientSessionAssignmentSequence]
                        WHERE
                            [PatientSessionAssignmentSequence].[r] = 1
                    )                  AS [LatestPatientSessionAssignment]
                        ON [LatestPatientSessionAssignment].[PatientSessionID] = [ps].[PatientSessionID]
            GROUP BY
                [LatestPatientSessionAssignment].[PatientID]
        ) AS [CombinedView]
    GROUP BY
        [CombinedView].[PatientID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patient ID''s and the number of days since each patients'' last discharge.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatientDaysSinceLastDischarge';

