CREATE PROCEDURE [dbo].[usp_CA_GetPatientWaveForms]
    (
     @patient_id UNIQUEIDENTIFIER,
     @channelIds [dbo].[StringList] READONLY,
     @start_ft BIGINT,
     @end_ft BIGINT
    )
AS
BEGIN
    DECLARE @start_ut DATETIME = [dbo].[fnFileTimeToDateTime](@start_ft);
    DECLARE @end_ut DATETIME = [dbo].[fnFileTimeToDateTime](@end_ft);

    SELECT
        --[dbo].[fnDateTimeToFileTime]([wd].[StartTimeUTC]) AS [start_ft],
        --[dbo].[fnDateTimeToFileTime]([wd].[EndTimeUTC]) AS [end_ft],
        [start_ft].[FileTime] AS [start_ft],
        [end_ft].[FileTime] AS [end_ft],
        CAST(NULL AS DATETIME) AS [start_dt],
        CAST(NULL AS DATETIME) AS [end_dt],
        CASE WHEN [wd].[Compressed] = 0 THEN NULL
             ELSE 'WCTZLIB'
        END AS [compress_method],
        [wd].[Samples] AS [waveform_data],
        [wd].[TypeId] AS [channel_id]
    FROM
        [dbo].[WaveformData] AS [wd]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([wd].[StartTimeUTC]) AS [start_ft]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([wd].[EndTimeUTC]) AS [end_ft]
    WHERE
        [wd].[TypeId] IN (SELECT
                            [Item]
                          FROM
                            @channelIds)
        AND [wd].[TopicSessionId] IN (SELECT
                                        [vpts].[TopicSessionId]
                                      FROM
                                        [dbo].[v_PatientTopicSessions] AS [vpts]
                                      WHERE
                                        [vpts].[PatientId] = @patient_id)
        AND [wd].[StartTimeUTC] <= @end_ut
        AND [wd].[EndTimeUTC] > @start_ut

    UNION ALL

    SELECT
        [iw].[start_ft],
        [iw].[end_ft],
        [iw].[start_dt],
        [iw].[end_dt],
        [iw].[compress_method],
        CAST([iw].[waveform_data] AS VARBINARY(MAX)),
        [ipc].[channel_type_id] AS [channel_id]
    FROM
        [dbo].[int_waveform] AS [iw]
        INNER JOIN [dbo].[int_patient_channel] AS [ipc]
            ON [iw].[patient_channel_id] = [ipc].[patient_channel_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [ipm]
            ON [ipc].[patient_monitor_id] = [ipm].[patient_monitor_id]
        INNER JOIN [dbo].[int_encounter] AS [ie]
            ON [ipm].[encounter_id] = [ie].[encounter_id]
    WHERE
        [iw].[patient_id] = @patient_id
        AND [ipc].[channel_type_id] IN (SELECT
                                            [Item]
                                        FROM
                                            @channelIds)
        AND @start_ft < [iw].[end_ft]
        AND @end_ft >= [iw].[start_ft]

    ORDER BY
        [start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the waveform data for the given list of channels from which to make Waveform requests.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetPatientWaveForms';

