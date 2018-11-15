CREATE PROCEDURE [old].[uspGetPatientWaveformTimeHistory] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iw].[StartDateTime]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
            INNER JOIN
                [Intesys].[Waveform]   AS [iw]
                    ON [ipc].[PatientChannelID] = [iw].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID
        UNION ALL
        SELECT
            [wd].[StartDateTime]
        FROM
            [old].[Waveform]         AS [wd]
            INNER JOIN
                [old].[TopicSession] AS [ts]
                    ON [ts].[TopicSessionID] = [wd].[TopicSessionID]
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
        ORDER BY
            [iw].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patients'' waveform time history starting date time.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientWaveformTimeHistory';

