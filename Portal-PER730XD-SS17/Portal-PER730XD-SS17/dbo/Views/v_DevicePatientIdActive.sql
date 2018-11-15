CREATE VIEW [dbo].[v_DevicePatientIdActive]
WITH SCHEMABINDING
AS
SELECT DISTINCT
       [LatestPatientAssignment].[DeviceId],
       [imm].[mrn_xid] AS [ID1],
       [LatestPatientSessionsMap].[PatientId]
FROM [dbo].[PatientSessions] AS [ps]
    INNER JOIN (SELECT
                    [PatientAssignmentSequence].[PatientSessionId],
                    [PatientAssignmentSequence].[DeviceId]
                FROM (SELECT
                          [pd].[PatientSessionId],
                          [ds].[DeviceId],
                          ROW_NUMBER() OVER (PARTITION BY [pd].[PatientSessionId]
                                             ORDER BY [pd].[TimestampUTC] DESC) AS [RowNumber]
                      FROM [dbo].[PatientData] AS [pd]
                          INNER JOIN [dbo].[DeviceSessions] AS [ds]
                              ON [ds].[EndTimeUTC] IS NULL
                                 AND [ds].[Id] = [pd].[DeviceSessionId]) AS [PatientAssignmentSequence]
                WHERE [PatientAssignmentSequence].[RowNumber] = 1) AS [LatestPatientAssignment]
        ON [LatestPatientAssignment].[PatientSessionId] = [ps].[Id]
    INNER JOIN (SELECT
                    [PatientSessionsMapSequence].[PatientSessionId],
                    [PatientSessionsMapSequence].[PatientId]
                FROM (SELECT
                          [psm].[PatientSessionId],
                          [psm].[PatientId],
                          ROW_NUMBER() OVER (PARTITION BY [psm].[PatientSessionId]
                                             ORDER BY [psm].[Sequence] DESC) AS [RowNumber]
                      FROM [dbo].[PatientSessionsMap] AS [psm]) AS [PatientSessionsMapSequence]
                WHERE [PatientSessionsMapSequence].[RowNumber] = 1) AS [LatestPatientSessionsMap]
        ON [LatestPatientSessionsMap].[PatientSessionId] = [ps].[Id]
    INNER JOIN [dbo].[int_mrn_map] AS [imm]
        ON [imm].[patient_id] = [LatestPatientSessionsMap].[PatientId]
           AND [imm].[merge_cd] = 'C';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DevicePatientIdActive';

