CREATE PROCEDURE [old].[uspGetPatientVitalsTimeHistory]
    (
        @PatientID INT,
        @Debug     BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery VARCHAR(MAX)
            = '
SELECT DISTINCT
		[ir].[ResultDateTime]
	FROM
		[Intesys].[Result] AS [ir]
	WHERE
		[ir].[PatientID] = @PatientID
		
UNION ALL

	SELECT [v].[Timestamp] AS [ResultDateTime]
    FROM [old].[Vital] AS [v]
	INNER JOIN [old].[TopicSession] AS [ts] ON [v].[TopicSessionID] = [ts].[TopicSessionID]
	WHERE [ts].[PatientSessionID] IN
	(
		SELECT [PatientSessionID]
		FROM [old].[PatientSessionsMap]
		INNER JOIN
		(
		SELECT MAX(Sequence) AS MaxSeq
			FROM [old].[PatientSessionsMap]
			GROUP BY [PatientSessionID]
		) AS [PatientSessionMaxSeq]
			ON [Sequence] = [PatientSessionMaxSeq].[MaxSeq]
		WHERE [PatientID] = @PatientID
	)
'       ;

        SET @SqlQuery = REPLACE(@SqlQuery, '@PatientID', QUOTENAME(@PatientID, ''''));

        SET @SqlQuery = @SqlQuery + ' ORDER BY [ResultDateTime] ASC;';

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patients'' vitals time history.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsTimeHistory';

