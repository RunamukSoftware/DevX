CREATE PROCEDURE [old].[uspGetPatientVitalsTimeUpdate]
    (
        @PatientID     INT,
        @AfterDateTime DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ir].[ResultDateTime]
        FROM
            [Intesys].[Result] AS [ir]
        WHERE
            [ir].[PatientID] = @PatientID
            AND [ir].[ResultDateTime] > @AfterDateTime
        UNION ALL
        SELECT
            [vd].[Timestamp] AS [ResultDateTime]
        FROM
            [old].[Vital]       AS [vd]
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
            AND [vd].[Timestamp] > @AfterDateTime
        ORDER BY
            [ir].[ResultDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patients'' vitals time update.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsTimeUpdate';

