CREATE PROCEDURE [old].[uspGetPatientVitalsTypes] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [Code].[CodeID]       AS [Type],
            [Code].[Code],
            [Code].[KeystoneCode] AS [UNITS]
        FROM
            [Intesys].[MiscellaneousCode] AS [Code]
            INNER JOIN
                (
                    SELECT DISTINCT
                        [ir].[TestCodeID]
                    FROM
                        [Intesys].[Result] AS [ir]
                    WHERE
                        [ir].[PatientID] = @PatientID
                )                         AS [resultCodeID]
                    ON [resultCodeID].[TestCodeID] = [Code].[CodeID]
        UNION ALL
        SELECT
            [gcm].[CodeID]  AS [Type],
            [gcm].[GlobalDataSystemCode] AS [CODE],
            [gcm].[Units]   AS [UNITS]
        FROM
            [old].[GlobalDataSystemCodeMap] AS [gcm]
            INNER JOIN
                (
                    SELECT DISTINCT
                        [vd].[Name],
                        [vd].[FeedTypeID]
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
                )              AS [VitalTypes]
                    ON [gcm].[FeedTypeID] = [VitalTypes].[FeedTypeID]
                       AND [gcm].[Name] = [VitalTypes].[Name];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the patients'' vitals types, codes and units.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVitalsTypes';

