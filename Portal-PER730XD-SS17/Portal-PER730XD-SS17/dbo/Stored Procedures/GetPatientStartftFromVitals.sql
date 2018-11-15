CREATE PROCEDURE [dbo].[GetPatientStartftFromVitals]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([start_ft].[start_ft]) AS [start_ft]
    FROM
        (SELECT
            MIN([result_ft]) AS [start_ft]
         FROM
            [dbo].[int_result]
         WHERE
            [patient_id] = @patient_id

         UNION ALL

         SELECT
            --[dbo].[fnDateTimeToFileTime](MIN([TimestampUTC])) AS [start_ft]
            MIN([start_ft].[FileTime]) AS [start_ft]
         FROM
            [dbo].[VitalsData]
         CROSS APPLY [dbo].[fntDateTimeToFileTime]([TimestampUTC]) AS [start_ft]
         WHERE
            [TopicSessionId] IN (SELECT
                                [TopicSessionId]
                               FROM
                                [dbo].[v_PatientTopicSessions]
                               WHERE
                                [PatientId] = @patient_id)
        ) AS [start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientStartftFromVitals';

