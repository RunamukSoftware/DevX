CREATE PROCEDURE [dbo].[GetPatientVitalsTimeUpdate]
  (
  @patient_id UNIQUEIDENTIFIER,
  @after_ft   BIGINT
  )
AS
BEGIN
    SELECT result_ft AS result_ft,
           result_dt
    FROM   dbo.int_result
    WHERE  patient_id = @patient_id AND result_ft > @after_ft    

    UNION ALL

    SELECT 
        --dbo.fnDateTimeToFileTime(TimestampUTC) AS result_ft, 
        [result_ft].[FileTime] AS result_ft, 
        CAST(NULL AS DATETIME) as result_dt
        FROM [dbo].[VitalsData]
        INNER JOIN [dbo].[TopicSessions] on TopicSessions.Id = VitalsData.TopicSessionId
        CROSS APPLY [dbo].[fntDateTimeToFileTime](TimestampUTC) AS [result_ft]
        WHERE TopicSessions.PatientSessionId in
        (
            SELECT PatientSessionId
            FROM dbo.PatientSessionsMap
            INNER JOIN
            (
            SELECT MAX(Sequence) AS MaxSeq
                FROM dbo.PatientSessionsMap
                GROUP BY PatientSessionId
            ) AS PatientSessionMaxSeq
                ON Sequence = PatientSessionMaxSeq.MaxSeq
            WHERE PatientId = @patient_id
        )
        AND
        [result_ft].[FileTime] > @after_ft

    ORDER  BY result_ft
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patients'' vitals time update.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalsTimeUpdate';

