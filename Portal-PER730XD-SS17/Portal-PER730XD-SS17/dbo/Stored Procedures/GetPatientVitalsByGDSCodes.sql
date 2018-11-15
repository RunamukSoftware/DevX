CREATE PROCEDURE [dbo].[GetPatientVitalsByGDSCodes]
    (
     @gds_codes [dbo].[GdsCodes] READONLY,
     @patient_id UNIQUEIDENTIFIER,
     @start_dt_utc DATETIME, --UTC
     @end_dt_utc DATETIME --UTC
    )
AS
BEGIN
    DECLARE @start_ft BIGINT = [dbo].[fnDateTimeToFileTime](@start_dt_utc);
    DECLARE @end_ft BIGINT = [dbo].[fnDateTimeToFileTime](@end_dt_utc);

    SELECT
        [vitals].[RowNumber] AS [ROW_NUMBER],
        [vitals].[GDS_CODE],
        [vitals].[VALUE],
        [vitals].[RESULT_TIME],
        [vitals].[RESULT_FILE_TIME],
        [vitals].[IS_RESULT_LOCALIZED]
    FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [imc].[code] ORDER BY [ir].[result_ft] DESC) AS [RowNumber],
            [imc].[code] AS [GDS_CODE],
            [ir].[result_value] AS [VALUE],
            CAST(NULL AS DATETIME) AS [RESULT_TIME],
            [ir].[result_ft] AS [RESULT_FILE_TIME],
            CAST(1 AS BIT) AS [IS_RESULT_LOCALIZED]
         FROM
            [dbo].[int_result] AS [ir]
            INNER JOIN [dbo].[int_misc_code] AS [imc]
                ON [imc].[code_id] = [ir].[test_cid]
            INNER JOIN @gds_codes AS [codes]
                ON [imc].[code] = [codes].[GdsCode]
         WHERE
            [ir].[patient_id] = @patient_id
            AND [ir].[result_ft] >= @start_ft
            AND [ir].[result_ft] <= @end_ft
            AND [ir].[result_value] IS NOT NULL

         UNION ALL

         SELECT
            ROW_NUMBER() OVER (PARTITION BY [vd].[FeedTypeId], [vd].[TopicSessionId] ORDER BY [vd].[TimestampUTC] DESC) AS [RowNumber],
            [gcm].[GdsCode] AS [GDS_CODE],
            [vd].[Value] AS [VALUE],
            CAST(NULL AS DATETIME) AS [RESULT_TIME],
            --[dbo].[fnDateTimeToFileTime]([vd].[TimestampUTC]) AS [RESULT_FILE_TIME],
            [RESULT_FILE_TIME].[FileTime] AS [RESULT_FILE_TIME],
            CAST(0 AS BIT) AS [IS_RESULT_LOCALIZED]
         FROM
            [dbo].[VitalsData] AS [vd]
            INNER JOIN [dbo].[GdsCodeMap] AS [gcm]
                ON [gcm].[FeedTypeId] = [vd].[FeedTypeId]
                   AND [gcm].[Name] = [vd].[Name]
            INNER JOIN @gds_codes AS [codes]
                ON [codes].[GdsCode] = [gcm].[GdsCode]
            INNER JOIN [dbo].[v_PatientTopicSessions]
                ON [v_PatientTopicSessions].[TopicSessionId] = [vd].[TopicSessionId]
            CROSS APPLY [dbo].[fntDateTimeToFileTime]([vd].[TimestampUTC]) AS [RESULT_FILE_TIME]
         WHERE
            [PatientId] = @patient_id
            AND [vd].[TimestampUTC] >= @start_dt_utc
            AND [vd].[TimestampUTC] <= @end_dt_utc
        ) AS [vitals]
    WHERE
        [vitals].[RowNumber] = 1
	ORDER BY RESULT_FILE_TIME DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient vitals by GDS codes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientVitalsByGDSCodes';

