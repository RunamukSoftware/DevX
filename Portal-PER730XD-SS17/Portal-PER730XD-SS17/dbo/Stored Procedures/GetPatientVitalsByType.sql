CREATE PROCEDURE [dbo].[GetPatientVitalsByType] (@patient_id UNIQUEIDENTIFIER, @type int)
AS
BEGIN
    (SELECT 
      Result.result_value AS VALUE, 
      CAST(NULL AS DATETIME) AS RESULT_TIME,
      Result.Sequence AS SEQ_NUM,
      Result.result_ft AS RESULT_FILE_TIME,
      CAST(1 AS BIT) AS [IS_RESULT_LOCALIZED]
    FROM 
      [dbo].[int_result] AS [Result] 
      INNER JOIN [dbo].[int_misc_code] AS [Code] ON Result.test_cid = Code.code_id 
    WHERE
      (Result.patient_id = @patient_id) AND 
      (Code.code_id = @type) 
  
UNION ALL  

SELECT 
      VitalsData.Value AS VALUE, 	  
      CAST(NULL AS DATETIME) AS RESULT_TIME,	  
      0 AS SEQ_NUM,
      [TimestampUTCFileTime].[FileTime] AS [RESULT_FILE_TIME], -- Use the Table Value Function column to improve performance
      CAST(0 AS BIT) AS [IS_RESULT_LOCALIZED]
      FROM [dbo].[VitalsData]
      INNER JOIN 
      [dbo].[GdsCodeMap] ON
        GdsCodeMap.CodeId = @type AND 
        GdsCodeMap.FeedTypeId = VitalsData.FeedTypeId AND
        GdsCodeMap.Name = VitalsData.Name
      INNER JOIN
      dbo.TopicSessions ON TopicSessions.Id = VitalsData.TopicSessionId
      CROSS APPLY [dbo].[fntDateTimeToFileTime]([TimestampUTC]) AS [TimestampUTCFileTime] -- Use the Table Value Function instead to improve performance
      WHERE TopicSessions.PatientSessionId =
      (
      SELECT TOP (1) PatientSessionId
        FROM dbo.PatientSessionsMap
        INNER JOIN
        (
        SELECT MAX(Sequence) AS MaxSeq
            FROM dbo.PatientSessionsMap
            WHERE PatientId = @patient_id -- Include @patient_id within the inner query to get only the patient session we requested instead of all patient sessions
            GROUP BY PatientSessionId
        ) AS PatientSessionMaxSeq
            ON Sequence = PatientSessionMaxSeq.MaxSeq
      )
  )
ORDER BY 
  RESULT_FILE_TIME ASC;
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals by type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalsByType';

