CREATE PROCEDURE [dbo].[GetPatientChannelTimes]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([iw].[start_ft]) AS [MIN_START_FT],
        MAX([iw].[end_ft]) AS [MAX_END_FT],
        [ict].[channel_code] AS [CHANNEL_CODE],
        NULL AS [LABEL],
        [ict].[priority],
        [ict].[channel_type_id] AS [CHANNEL_TYPE_ID],
        [ict].[freq] AS [SAMPLE_RATE]
    FROM
        [dbo].[int_waveform] AS [iw]
        INNER JOIN [dbo].[int_patient_channel] AS [ipc]
            ON [iw].[patient_channel_id] = [ipc].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] AS [ict]
            ON [ipc].[channel_type_id] = [ict].[channel_type_id]
    WHERE
        [iw].[patient_id] = @patient_id
    GROUP BY
        [ict].[channel_code],
        [ict].[label],
        [ict].[priority],
        [ict].[channel_type_id],
        [ict].[freq]

    UNION ALL

    SELECT
        --[dbo].[fnDateTimeToFileTime](MIN([wd].[StartTimeUTC])) AS [MIN_START_FT],
        --[dbo].[fnDateTimeToFileTime](MAX([wd].[EndTimeUTC])) AS [MAX_END_FT],
        MIN([MIN_START_FT].[FileTime]) AS [MIN_START_FT],
        MAX([MAX_END_FT].[FileTime]) AS [MAX_END_FT],
        [tft].[ChannelCode] AS [CHANNEL_CODE],
        NULL AS [LABEL],
        [ict].[priority] AS [priority],
        [wd].[TypeId] AS [CHANNEL_TYPE_ID],
        [tft].[SampleRate] AS [SAMPLE_RATE]
    FROM
        [dbo].[WaveformData] AS [wd]
        INNER JOIN [dbo].[TopicFeedTypes] AS [tft]
            ON [tft].[FeedTypeId] = [wd].[TypeId]
        LEFT OUTER JOIN [dbo].[int_channel_type] AS [ict]
            ON [ict].[channel_code] = [tft].[ChannelCode]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([wd].[StartTimeUTC]) AS [MIN_START_FT]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([wd].[EndTimeUTC]) AS [MAX_END_FT]
    WHERE
        [wd].[TopicSessionId] IN (SELECT
                                    [vpts].[TopicSessionId]
                                  FROM
                                    [dbo].[v_PatientTopicSessions] AS [vpts]
                                  WHERE
                                    [vpts].[PatientId] = @patient_id)
    GROUP BY
        [tft].[ChannelCode],
        [wd].[TypeId],
        [tft].[SampleRate],
        [ict].[priority]

    ORDER BY
        [ict].[priority];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient channel times.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientChannelTimes';

