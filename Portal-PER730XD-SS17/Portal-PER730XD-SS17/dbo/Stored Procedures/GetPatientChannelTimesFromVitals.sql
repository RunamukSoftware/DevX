CREATE PROCEDURE [dbo].[GetPatientChannelTimesFromVitals]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([ir].[result_ft]) AS [MIN_START_FT],
        MAX([ir].[result_ft]) AS [MAX_END_FT],
        [ict].[channel_code] AS [CHANNEL_CODE],
        [ict].[label] AS [LABEL],
        [ict].[priority],
        [ict].[channel_type_id] AS [CHANNEL_TYPE_ID],
        [ict].[freq] AS [SAMPLE_RATE]
    FROM
        [dbo].[int_result] AS [ir]
        INNER JOIN [dbo].[int_patient_channel] AS [ipc]
            ON [ir].[patient_id] = [ipc].[patient_id]
        INNER JOIN [dbo].[int_channel_type] AS [ict]
            ON [ipc].[channel_type_id] = [ict].[channel_type_id]
    GROUP BY
        [ir].[patient_id],
        [ict].[channel_code],
        [ict].[label],
        [ict].[priority],
        [ict].[channel_type_id],
        [ict].[freq]
    HAVING
        [ir].[patient_id] = @patient_id

    UNION ALL

    SELECT
        --[dbo].[fnDateTimeToFileTime](MIN([vd].[TimestampUTC])) AS [MIN_START_FT],
        --[dbo].[fnDateTimeToFileTime](MAX([vd].[TimestampUTC])) AS [MAX_END_FT],
        MIN([MIN_START_FT].[FileTime]) AS [MIN_START_FT],
        MAX([MAX_END_FT].[FileTime]) AS [MAX_END_FT],
        [tft].[ChannelCode] AS [CHANNEL_CODE],
        [ict].[label] AS [LABEL],
        [ict].[priority],
        [tft].[FeedTypeId] AS [CHANNEL_TYPE_ID],
        [tft].[SampleRate] AS [SAMPLE_RATE]
    FROM
        [dbo].[VitalsData] AS [vd]
        INNER JOIN [dbo].[TopicSessions] AS [ts]
            ON [ts].[Id] = [vd].[TopicSessionId]
        INNER JOIN [dbo].[TopicFeedTypes] AS [tft]
            ON [tft].[TopicTypeId] = [ts].[TopicTypeId]
        INNER JOIN [dbo].[int_channel_type] AS [ict]
            ON [ict].[channel_code] = [tft].[ChannelCode]
        INNER JOIN [dbo].[v_PatientTopicSessions] AS [vpts]
            ON [vpts].[TopicSessionId] = [ts].[Id]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([vd].[TimestampUTC]) AS [MIN_START_FT]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([vd].[TimestampUTC]) AS [MAX_END_FT]
    WHERE
        [PatientId] = @patient_id
        AND [tft].[SampleRate] IS NOT NULL
    GROUP BY
        [tft].[FeedTypeId],
        [tft].[ChannelCode],
        [ict].[label],
        [tft].[SampleRate],
        [ict].[priority]

    ORDER BY
        [ict].[priority];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient channel start and end times from vitals.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientChannelTimesFromVitals';

