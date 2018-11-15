CREATE PROCEDURE [dbo].[GetPatientVitalsTimeHistory] (@patient_id UNIQUEIDENTIFIER)
AS
BEGIN
    --DECLARE @sql VARCHAR(MAX) = '
    --SELECT distinct
    --		result_ft,
    --		result_dt
    --	FROM
    --		dbo.int_result
    --	WHERE
    --		patient_id = @patient_id

    --UNION ALL

    --	SELECT DISTINCT dbo.fnDateTimeToFileTime(TimestampUTC) as result_ft, dbo.fnUtcDateTimeToLocalTime(TimestampUTC) as result_dt from [dbo].[VitalsData]
    --	inner join dbo.TopicSessions on VitalsData.TopicSessionId = TopicSessions.Id
    --	WHERE TopicSessions.PatientSessionId IN
    --	(
    --		SELECT PatientSessionId
    --		FROM dbo.PatientSessionsMap
    --		INNER JOIN
    --		(
    --		SELECT MAX(Sequence) AS MaxSeq
    --			FROM dbo.PatientSessionsMap
    --			GROUP BY PatientSessionId
    --		) AS PatientSessionMaxSeq
    --			ON Sequence = PatientSessionMaxSeq.MaxSeq
    --		WHERE PatientId = @patient_id
    --	)
    --'
    --SET @sql = REPLACE(@sql, '@patient_id', QUOTENAME(@patient_id, ''''))

    --SET @sql = @sql + ' ORDER BY result_ft asc'

    --EXEC (@sql)

    SELECT DISTINCT
           [ir].[result_ft],
           [ir].[result_dt]
    FROM [dbo].[int_result] AS [ir]
    WHERE [ir].[patient_id] = @patient_id
    UNION ALL
    SELECT DISTINCT
           --[dbo].[fnDateTimeToFileTime]([vd].[TimestampUTC]) AS [result_ft],
           --[dbo].[fnUtcDateTimeToLocalTime]([vd].[TimestampUTC]) AS [result_dt]
           [result_ft].[FileTime] AS [result_ft],
           [result_dt].[LocalDateTime] AS [result_dt]
    FROM [dbo].[VitalsData] AS [vd]
        INNER JOIN [dbo].[TopicSessions] AS [ts]
            ON [vd].[TopicSessionId] = [ts].[Id]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([vd].[TimestampUTC]) AS [result_ft]
        CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([vd].[TimestampUTC]) AS [result_dt]
    WHERE [ts].[PatientSessionId] IN (SELECT [psm].[PatientSessionId]
                                      FROM [dbo].[PatientSessionsMap] AS [psm]
                                          INNER JOIN (SELECT MAX([psm2].[Sequence]) AS [MaxSeq]
                                                      FROM [dbo].[PatientSessionsMap] AS [psm2]
                                                      GROUP BY [psm2].[PatientSessionId]) AS [PatientSessionMaxSeq]
                                              ON [psm].[Sequence] = [PatientSessionMaxSeq].[MaxSeq]
                                      WHERE [psm].[PatientId] = @patient_id)
    ORDER BY [ir].[result_ft] ASC;

--IF (@Debug = 1)
--    PRINT @sql;

--EXEC (@sql);
END;
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Get the patients'' vitals time history.',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'PROCEDURE',
    @level1name = N'GetPatientVitalsTimeHistory';
