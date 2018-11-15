CREATE PROCEDURE [old].[uspGetPatientVitalsByType]
    (
        @PatientID INT,
        @Type      INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        --SELECT
        --     [Result].[result_value] AS [VALUE],
        --     CAST(NULL AS DATETIME2(7)) AS [RESULT_TIME],
        --     [Result].[Sequence] AS [SequenceNumber],
        --     [Result].[ResultDateTime] AS [ResultFileTime],
        --     CAST(1 AS BIT) AS [IsResultLocalized]
        -- FROM [Intesys].[result] AS [Result]
        --     INNER JOIN [Intesys].[misc_code] AS [Code]
        --         ON [Result].[TestCodeID] = [Code].[CodeID]
        -- WHERE [Result].[PatientID] = @PatientID
        --       AND [Code].[CodeID] = @Type
        -- UNION ALL
        SELECT
            [vd].[Value]               AS [VALUE],
            CAST(NULL AS DATETIME2(7)) AS [RESULT_TIME],
            0                          AS [SequenceNumber],
            [vd].[Timestamp]        AS [ResultFileTime], -- Use the Table Value Function column to improve performance
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
                                                       WHERE
                                                           [psm2].[PatientID] = @PatientID -- Include @PatientID within the inner query to get only the patient session we requested instead of all patient sessions
                                                       GROUP BY
                                                           [psm2].[PatientSessionID]
                                                   )                     AS [PatientSessionMaxSeq]
                                                       ON [psm].[PatientSessionMapID] = [PatientSessionMaxSeq].[MaxSeq]
                                       )
        ORDER BY
            [ResultFileTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals by Type.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsByType';

