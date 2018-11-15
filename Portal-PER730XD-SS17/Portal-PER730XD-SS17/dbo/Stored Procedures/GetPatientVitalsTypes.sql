CREATE PROCEDURE [dbo].[GetPatientVitalsTypes] (@patient_id UNIQUEIDENTIFIER) 
AS
BEGIN
    SELECT 
        Code.code_id AS [TYPE],
        Code.code AS [CODE],
        Code.int_keystone_cd AS [UNITS]
    FROM 
      [dbo].[int_misc_code] AS [Code]
      INNER JOIN 
      (
          SELECT DISTINCT test_cid 
          FROM [dbo].[int_result]
          WHERE patient_id = @patient_id
      ) AS [result_cid]
      ON result_cid.test_cid = Code.code_id
    
    UNION ALL

    SELECT 
        GdsCodeMap.CodeId AS [TYPE],
        GdsCodeMap.GdsCode AS [CODE],
        GdsCodeMap.Units AS [UNITS]
    FROM [dbo].[GdsCodeMap] 
        INNER JOIN 
        (	SELECT DISTINCT [VitalsData].[Name], [VitalsData].[FeedTypeId] 
            FROM [dbo].[VitalsData]
            INNER JOIN [dbo].[TopicSessions] on TopicSessions.Id = VitalsData.TopicSessionId
            WHERE TopicSessions.PatientSessionId IN
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
        ) AS VitalTypes 
        ON GdsCodeMap.FeedTypeId = [VitalTypes].[FeedTypeId] 
        AND GdsCodeMap.[Name] = [VitalTypes].[Name]

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals types, codes and units.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalsTypes';

