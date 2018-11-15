CREATE PROCEDURE [dbo].[GetPatientVitalsByTypeUpdate]
  (
  @patient_id    UNIQUEIDENTIFIER,
  @type          INT,
  @seq_num_after BIGINT,
  @dateAfter	 BIGINT
  )
AS
  BEGIN
   
   DECLARE @l_dateAfter DATETIME = dbo.fnFileTimeToDateTime(@dateAfter);

    SELECT RESULT.result_value AS VALUE,
           CAST(NULL AS DATETIME) AS RESULT_TIME,
           RESULT.Sequence AS SEQ_NUM,
           RESULT.result_ft AS RESULT_FILE_TIME,
           CAST(1 AS BIT) AS [IS_RESULT_LOCALIZED]
    FROM   [dbo].[int_result] AS RESULT
           INNER JOIN [dbo].[int_misc_code] AS CODE
             ON RESULT.test_cid = CODE.code_id
    WHERE  RESULT.patient_id = @patient_id AND CODE.code_id = @type AND RESULT.Sequence > @seq_num_after

    UNION ALL  

    SELECT 
      VitalsData.Value AS VALUE, 	  
      CAST(NULL AS DATETIME) AS RESULT_TIME,	  
      0 AS SEQ_NUM,
      --dbo.fnDateTimeToFileTime(VitalsData.TimestampUTC) AS RESULT_FILE_TIME,
      [RESULT_FILE_TIME].[FileTime] AS RESULT_FILE_TIME,
      CAST(0 AS BIT) AS [IS_RESULT_LOCALIZED]
      FROM [dbo].[VitalsData]
      INNER JOIN 
      [dbo].[GdsCodeMap] ON
        GdsCodeMap.CodeId = @type AND 
        GdsCodeMap.FeedTypeId = VitalsData.FeedTypeId AND
        GdsCodeMap.Name = VitalsData.Name
      INNER JOIN
      dbo.TopicSessions ON TopicSessions.Id = VitalsData.TopicSessionId
      CROSS APPLY [dbo].[fntDateTimeToFileTime](VitalsData.TimestampUTC) AS [RESULT_FILE_TIME]
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
      AND (TimestampUTC > @l_dateAfter)

    ORDER  BY RESULT_FILE_TIME ASC;
  END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals by type after sequence number and after date.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalsByTypeUpdate';

