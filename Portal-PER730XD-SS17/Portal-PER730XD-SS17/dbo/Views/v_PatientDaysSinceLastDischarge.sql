CREATE VIEW [dbo].[v_PatientDaysSinceLastDischarge]
AS
SELECT [PatientId], MIN([DaysSinceLastDischarge]) AS [DaysSinceLastDischarge]
FROM
(
	SELECT [PatientId] = [patient_id],
	       [DaysSinceLastDischarge] = MIN(DATEDIFF(day, ISNULL([discharge_dt], GETDATE()), GETDATE()))
		FROM [dbo].[int_encounter]
		GROUP BY [patient_id]

UNION ALL

	SELECT [PatientId]
	      ,[DaysSinceLastDischarge] = MIN(DATEDIFF(day, ISNULL([EndTimeUTC], GETUTCDATE()), GETUTCDATE()))
		FROM [dbo].[PatientSessions]
		INNER JOIN
		(
			SELECT [PatientSessionId]
			      ,[PatientId]
				FROM
				(
					SELECT [PatientSessionId]
					      ,[PatientId]
						  ,[R] = ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [Sequence] DESC)
						FROM [dbo].[PatientSessionsMap]
				) AS [PatientSessionAssignmentSequence]
				WHERE [R]=1
		) AS [LatestPatientSessionAssignment]
			ON [LatestPatientSessionAssignment].[PatientSessionId]=[PatientSessions].[Id]
		GROUP BY [PatientId]
) AS [CombinedView]
GROUP BY PatientId

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patient ID''s and the number of days since each patients'' last discharge.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PatientDaysSinceLastDischarge';

