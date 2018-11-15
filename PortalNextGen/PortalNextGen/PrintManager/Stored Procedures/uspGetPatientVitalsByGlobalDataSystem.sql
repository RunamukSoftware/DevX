CREATE PROCEDURE [PrintManager].[uspGetPatientVitalsByGlobalDataSystem]
    (
        @GlobalDataSystemCodes [old].[utpGlobalDataSystemCodeTable] READONLY,
        @PatientID             INT,
        @StartTimeUTC          DATETIME2(7),
        @EndDateTime           DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [Vitals].[GlobalDataSystemCode],
            [Vitals].[Name],
            [Vitals].[Value],
            [Vitals].[ResultDateTime]
        FROM
            (
                SELECT
                        [Vitals].[GlobalDataSystemCode],
                        [Vitals].[Name],
                        [Vitals].[Value],
                        [Vitals].[ResultDateTime]
                FROM
                        [Intesys].[PrintJobEnhancedTelemetryVital] AS [Vitals]
                    INNER JOIN
                        (
                            SELECT
                                [GlobalDataSystemCode]
                            FROM
                                @GlobalDataSystemCodes
                        )                                          AS [Codes]
                            ON [Codes].[GlobalDataSystemCode] = [Vitals].[GlobalDataSystemCode]
                WHERE
                        [Vitals].[PatientID] = @PatientID
                        AND [Vitals].[ResultDateTime] >= @StartTimeUTC
                        AND [Vitals].[ResultDateTime] <= @EndDateTime
                UNION ALL
                SELECT
                        [GlobalDataSystemCode],
                        [Vital].[Name],
                        [Value],
                        [Timestamp] AS [ResultDateTime]
                FROM
                        [old].[Vital]
                    INNER JOIN
                        [old].[GlobalDataSystemCodeMap]
                            ON [GlobalDataSystemCode] IN (
                                                             SELECT
                                                                 [GlobalDataSystemCode]
                                                             FROM
                                                                 @GlobalDataSystemCodes
                                                         )
                               AND [GlobalDataSystemCodeMap].[FeedTypeID] = [Vital].[FeedTypeID]
                               AND [GlobalDataSystemCodeMap].[Name] = [Vital].[Name]
                WHERE
                        [TopicSessionID] IN (
                                                SELECT
                                                    [ts].[TopicSessionID]
                                                FROM
                                                    [old].[TopicSession] AS [ts]
                                                WHERE
                                                    [ts].[PatientSessionID] IN (
                                                                                   SELECT DISTINCT
                                                                                       [PatientSessionID]
                                                                                   FROM
                                                                                       [old].[PatientSessionMap]
                                                                                   WHERE
                                                                                       [PatientID] = @PatientID
                                                                               )
                                            )
                        AND [Timestamp] >= @StartTimeUTC
                        AND [Timestamp] <= @EndDateTime
                UNION ALL
                SELECT
                        [GlobalDataSystemCode],
                        [ld].[Name],
                        [ld].[Value],
                        [ld].[Timestamp] AS [ResultDateTime]
                FROM
                        [old].[LiveData] AS [ld]
                    INNER JOIN
                        [old].[GlobalDataSystemCodeMap]
                            ON [GlobalDataSystemCode] IN (
                                                             SELECT
                                                                 [GlobalDataSystemCode]
                                                             FROM
                                                                 @GlobalDataSystemCodes
                                                         )
                               AND [GlobalDataSystemCodeMap].[FeedTypeID] = [ld].[FeedTypeID]
                               AND [GlobalDataSystemCodeMap].[Name] = [ld].[Name]
                WHERE
                        [ld].[TopicInstanceID] IN (
                                                      SELECT
                                                          [ts].[TopicInstanceID]
                                                      FROM
                                                          [old].[TopicSession] AS [ts]
                                                      WHERE
                                                          [ts].[PatientSessionID] IN (
                                                                                         SELECT DISTINCT
                                                                                             [PatientSessionID]
                                                                                         FROM
                                                                                             [old].[PatientSessionMap]
                                                                                         WHERE
                                                                                             [PatientID] = @PatientID
                                                                                     )
                                                          AND [ts].[EndDateTime] IS NULL
                                                  )
                        AND [ld].[Timestamp] >= @StartTimeUTC
                        AND [ld].[Timestamp] <= @EndDateTime
            ) AS [Vitals];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves Patient Vital information from the copied ET Vitals data.  @GlobalDataSystemCodes: The alarm id associated with the print job.  @PatientID: The patient ID associated with the patient vitals to return.  @StartTimeUTC: The start time to begin grabbing vitals from.  @EndDateTime:  The end time to finish grabbing vitals from.', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsByGlobalDataSystem';

