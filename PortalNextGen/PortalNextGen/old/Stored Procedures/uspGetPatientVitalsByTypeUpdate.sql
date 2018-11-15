CREATE PROCEDURE [old].[uspGetPatientVitalsByTypeUpdate]
    (
        @PatientID           INT,
        @Type                INT,
        @SequenceNumberAfter INT,
        @DateAfter           DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [RESULT].[ResultValue]     AS [VALUE],
            CAST(NULL AS DATETIME2(7)) AS [RESULT_TIME],
            [RESULT].[ResultID]        AS [SequenceNumber],
            [RESULT].[ResultDateTime]  AS [ResultFileTime],
            CAST(1 AS BIT)             AS [IsResultLocalized]
        FROM
            [Intesys].[Result]                AS [RESULT]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [CODE]
                    ON [RESULT].[TestCodeID] = [CODE].[CodeID]
        WHERE
            [RESULT].[PatientID] = @PatientID
            AND [CODE].[CodeID] = @Type
            AND [RESULT].[ResultID] > @SequenceNumberAfter
        UNION ALL
        SELECT
            [vd].[Value]               AS [VALUE],
            CAST(NULL AS DATETIME2(7)) AS [RESULT_TIME],
            0                          AS [SequenceNumber],
            [vd].[Timestamp]        AS [ResultFileTime],
            CAST(0 AS BIT)             AS [IsResultLocalized]
        FROM
            [old].[Vital]       AS [vd]
            INNER JOIN
                [old].[GlobalDataSystemCodeMap]   AS [gcm]
                    ON [gcm].[CodeID] = @Type
                       AND [gcm].[FeedTypeID] = [vd].[FeedTypeID]
                       AND [gcm].[Name] = [vd].[Name]
            INNER JOIN
                [old].[TopicSession] AS [ts]
                    ON [ts].[TopicSessionID] = [vd].[TopicSessionID]
        WHERE
            [ts].[PatientSessionID] IN (
                                           SELECT
                                               [psm].[PatientSessionID]
                                           FROM
                                               [old].[PatientSessionMap] AS [psm]
                                               INNER JOIN
                                                   (
                                                       SELECT
                                                           MAX([psm2].[PatientSessionMapID]) AS [MaxSeq]
                                                       FROM
                                                           [old].[PatientSessionMap] AS [psm2]
                                                       GROUP BY
                                                           [psm2].[PatientSessionID]
                                                   )                     AS [PatientSessionMaxSeq]
                                                       ON [psm].[PatientSessionMapID] = [PatientSessionMaxSeq].[MaxSeq]
                                           WHERE
                                               [psm].[PatientID] = @PatientID
                                       )
            AND [vd].[Timestamp] > @DateAfter
        ORDER BY
            [ResultFileTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals by Type after sequence number and after date.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsByTypeUpdate';

