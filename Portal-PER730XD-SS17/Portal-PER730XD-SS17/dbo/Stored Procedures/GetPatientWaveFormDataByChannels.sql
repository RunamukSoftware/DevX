CREATE PROCEDURE [dbo].[GetPatientWaveFormDataByChannels]
    (
     @ChannelTypes [dbo].[StringList] READONLY,
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [patient_channel_id],
        [patient_monitor_id],
        [Waveforms].[START_DT],
        [Waveforms].[END_DT],
        [Waveforms].[start_ft],
        [Waveforms].[end_ft],
        [Waveforms].[COMPRESS_METHOD],
        [WAVEFORM_DATA],
        [TOPIC_INSTANCE_ID]
    FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [TypeId] ORDER BY [StartTimeUTC] DESC) AS [RowNumber],
            [wld].[TypeId] AS [PATIENT_CHANNEL_ID],
            [DeviceSessionId] AS [patient_monitor_id],
            --[dbo].[fnUtcDateTimeToLocalTime]([wld].[StartTimeUTC]) AS [START_DT],
            --[dbo].[fnUtcDateTimeToLocalTime]([wld].[EndTimeUTC]) AS [END_DT],
            --[dbo].[fnDateTimeToFileTime]([wld].[StartTimeUTC]) AS [start_ft],
            --[dbo].[fnDateTimeToFileTime]([wld].[EndTimeUTC]) AS [end_ft],
            [START_DT].[LocalDateTime] AS [START_DT],
            [END_DT].[LocalDateTime] AS [END_DT],
            [start_ft].[FileTime] AS [start_ft],
            [end_ft].[FileTime] AS [end_ft],
            NULL AS [COMPRESS_METHOD],
            [wld].[Samples] AS [WAVEFORM_DATA],
            [wld].[TopicInstanceId] AS [TOPIC_INSTANCE_ID]
         FROM
            [dbo].[WaveformLiveData] AS [wld] WITH (SNAPSHOT)
            INNER JOIN [dbo].[TopicSessions] AS [ts] ON [ts].[TopicInstanceId] = [wld].[TopicInstanceId]
         CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([wld].[StartTimeUTC]) AS [START_DT]
         CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([wld].[EndTimeUTC]) AS [END_DT]
         CROSS APPLY [dbo].[fntDateTimeToFileTime]([wld].[StartTimeUTC]) AS [start_ft]
         CROSS APPLY [dbo].[fntDateTimeToFileTime]([wld].[EndTimeUTC]) AS [end_ft]
         WHERE
            [ts].[Id] IN (SELECT
                            [TopicSessionId]
                          FROM
                            [dbo].[v_PatientTopicSessions] AS [vpts]
                          WHERE
                            [vpts].[PatientId] = @PatientId)
            AND [TypeId] IN (SELECT
                                [Item]
                             FROM
                                @ChannelTypes)
            AND [ts].[EndTimeUTC] IS NULL
        ) AS [Waveforms]
    WHERE
        [Waveforms].[RowNumber] = 1

    UNION ALL

    SELECT
        [ipc].[channel_type_id] AS [PATIENT_CHANNEL_ID],
        [ipc].[patient_monitor_id],
        [WAVFRM].[start_dt] AS [START_DT],
        [WAVFRM].[end_dt] AS [END_DT],
        [WAVFRM].[start_ft] AS [start_ft],
        [WAVFRM].[end_ft] AS [end_ft],
        [WAVFRM].[compress_method] AS [COMPRESS_METHOD],
        [WAVFRM].[waveform_data] AS [WAVEFORM_DATA],
        NULL AS [TOPIC_INSTANCE_ID]
    FROM
        [dbo].[int_patient_channel] AS [ipc]
        LEFT OUTER JOIN [dbo].[int_waveform_live] AS [WAVFRM] ON [WAVFRM].[patient_channel_id] = [ipc].[patient_channel_id]
    WHERE
        [ipc].[patient_id] = @PatientId
        AND [ipc].[channel_type_id] IN (SELECT
                                            [Item]
                                        FROM
                                            @ChannelTypes)
        AND [ipc].[active_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientWaveFormDataByChannels';

