CREATE PROCEDURE [dbo].[GetPatientWaveFormTimeHistory]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [iw].[start_ft],
        [iw].[start_dt]
    FROM
        [dbo].[int_patient_channel] AS [ipc]
        INNER JOIN [dbo].[int_waveform] AS [iw]
            ON [ipc].[patient_channel_id] = [iw].[patient_channel_id]
    WHERE
        [iw].[patient_id] = @patient_id

    UNION 

    SELECT
        [start_ft].[FileTime] AS [start_ft],
        CAST(NULL AS DATETIME) AS [start_dt]
    FROM
        [dbo].[WaveformData] AS [wd]
        INNER JOIN [dbo].[TopicSessions] AS [ts]
            ON [ts].[Id] = [wd].[TopicSessionId]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([wd].[StartTimeUTC]) AS [start_ft]
    WHERE
        [ts].[PatientSessionId] IN (SELECT
                                        [psm].[PatientSessionId]
                                    FROM
                                        [dbo].[PatientSessionsMap] AS [psm]
                                        INNER JOIN (SELECT
                                                        MAX([psm2].[Sequence]) AS [MaxSeq]
                                                    FROM
                                                        [dbo].[PatientSessionsMap] AS [psm2]
                                                    WHERE
                                                        [psm2].[PatientId] = @patient_id
                                                    GROUP BY
                                                        [psm2].[PatientSessionId]
                                                   ) AS [PatientSessionMaxSeq]
                                            ON [psm].[Sequence] = [PatientSessionMaxSeq].[MaxSeq]
                                    WHERE
                                        [psm].[PatientId] = @patient_id)
    ORDER BY
        [iw].[start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patients'' waveform time history starting date time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientWaveFormTimeHistory';

