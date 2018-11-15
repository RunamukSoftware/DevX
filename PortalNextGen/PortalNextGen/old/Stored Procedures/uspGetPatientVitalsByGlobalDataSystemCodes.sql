CREATE PROCEDURE [old].[uspGetPatientVitalsByGlobalDataSystemCodes]
    (
        @GlobalDataSystemCodes [old].[utpGlobalDataSystemCodeTable] READONLY,
        @PatientID             INT,
        @StartDateTime         DATETIME2(7),
        @EndDateTime           DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [vitals].[RowNumber] AS [RowNumber],
            [vitals].[GlobalDataSystemCode],
            [vitals].[Value],
            [vitals].[ResultTime],
            [vitals].[ResultDateTime],
            [vitals].[IsResultLocalized]
        FROM
            (
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY
                                           [imc].[Code]
                                       ORDER BY
                                           [ir].[ResultDateTime] DESC
                                      )        AS [RowNumber],
                    [imc].[Code]               AS [GlobalDataSystemCode],
                    [ir].[ResultValue]         AS [Value],
                    CAST(NULL AS DATETIME2(7)) AS [ResultTime],
                    [ir].[ResultDateTime],
                    CAST(1 AS BIT)             AS [IsResultLocalized]
                FROM
                    [Intesys].[Result]                AS [ir]
                    INNER JOIN
                        [Intesys].[MiscellaneousCode] AS [imc]
                            ON [imc].[CodeID] = [ir].[TestCodeID]
                    INNER JOIN
                        @GlobalDataSystemCodes        AS [codes]
                            ON [imc].[Code] = [codes].[GlobalDataSystemCode]
                WHERE
                    [ir].[PatientID] = @PatientID
                    AND [ir].[ResultDateTime] >= @StartDateTime
                    AND [ir].[ResultDateTime] <= @EndDateTime
                    AND [ir].[ResultValue] IS NOT NULL
                UNION ALL
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY
                                           [vd].[FeedTypeID],
                                           [vd].[TopicSessionID]
                                       ORDER BY
                                           [vd].[Timestamp] DESC
                                      )                                AS [RowNumber],
                    [gcm].[GlobalDataSystemCode],
                    [vd].[Value],
                    CAST(NULL AS DATETIME2(7))                         AS [ResultTime],
                    [old].[ufnDateTimeToDateTime]([vd].[Timestamp]) AS [ResultDateTime],
                    CAST(0 AS BIT)                                     AS [IsResultLocalized]
                FROM
                    [old].[Vital]              AS [vd]
                    INNER JOIN
                        [old].[GlobalDataSystemCodeMap]     AS [gcm]
                            ON [gcm].[FeedTypeID] = [vd].[FeedTypeID]
                               AND [gcm].[Name] = [vd].[Name]
                    INNER JOIN
                        @GlobalDataSystemCodes AS [codes]
                            ON [codes].[GlobalDataSystemCode] = [gcm].[GlobalDataSystemCode]
                    INNER JOIN
                        [old].[vwPatientTopicSessions]
                            ON [vwPatientTopicSessions].[TopicSessionID] = [vd].[TopicSessionID]
                WHERE
                    [PatientID] = @PatientID
                    AND [vd].[Timestamp] >= @StartDateTime
                    AND [vd].[Timestamp] <= @EndDateTime
            ) AS [vitals]
        WHERE
            [vitals].[RowNumber] = 1
        ORDER BY
            [vitals].[ResultDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient vitals by Global Data System (GDS) codes.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsByGlobalDataSystemCodes';

