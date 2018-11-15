CREATE PROCEDURE [dbo].[usp_PM_CopyETWaveformData]
AS
BEGIN
    DECLARE @tMinusPaddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

    SELECT
        @tMinusPaddingSeconds = CAST([Value] AS INT)
    FROM
        [dbo].[ApplicationSettings]
    WHERE
        [ApplicationType] = 'Global'
        AND [Key] = 'PrintJobPaddingSeconds';

    IF @tMinusPaddingSeconds IS NULL
        RAISERROR(N'Global setting "%s" from the ApplicationSettings table was null or missing', 13, 1, N'PrintJobPaddingSeconds');

    MERGE [dbo].[int_print_job_et_waveform] AS [Target]
    USING
        (SELECT DISTINCT
            [AlarmTopics].[DeviceSessionId],
            [Waveform].[TimeStampBeginUTC] AS [StartTimeUTC],
            [Waveform].[TimeStampEndUTC] AS [EndTimeUTC],
            [Waveform].[SampleRate],
            [Waveform].[WaveformData],
            [ChannelTypes].[ChannelCode],
            [ChannelTypes].[CdiLabel]
         FROM
            [dbo].[v_LegacyWaveform] AS [Waveform]
            LEFT OUTER JOIN [dbo].[v_LegacyChannelTypes] AS [ChannelTypes] ON [Waveform].[TypeId] = [ChannelTypes].[TypeId]
            INNER JOIN (SELECT
                            [int_print_job_et_alarm].[DeviceSessionId],
                            MIN([int_print_job_et_alarm].[AlarmStartTimeUTC]) AS [MinAlarmStartTimeUTC],
                            MAX([int_print_job_et_alarm].[AlarmEndTimeUTC]) AS [MaxAlarmEndTimeUTC]
                        FROM
                            [dbo].[int_print_job_et_alarm]
                            INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[DeviceSessionId] = [int_print_job_et_alarm].[DeviceSessionId]
                        GROUP BY
                            [int_print_job_et_alarm].[DeviceSessionId]
                       ) AS [AlarmTopics] ON [AlarmTopics].[DeviceSessionId] = [Waveform].[DeviceSessionId]
         WHERE
            [Waveform].[TimeStampBeginUTC] < DATEADD(SECOND, @tMinusPaddingSeconds, [AlarmTopics].[MaxAlarmEndTimeUTC])
            AND [Waveform].[TimeStampEndUTC] > DATEADD(SECOND, -@tMinusPaddingSeconds, [AlarmTopics].[MinAlarmStartTimeUTC])
        ) AS [Source]
    ON [Target].[DeviceSessionId] = [Source].[DeviceSessionId]
        AND [Target].[StartTimeUTC] = [Source].[StartTimeUTC]
        AND [Target].[EndTimeUTC] = [Source].[EndTimeUTC]
        AND [Target].[ChannelCode] = [Source].[ChannelCode]
    WHEN NOT MATCHED THEN
        INSERT
               ([Id],
                [DeviceSessionId],
                [StartTimeUTC],
                [EndTimeUTC],
                [SampleRate],
                [WaveformData],
                [ChannelCode],
                [CdiLabel]
               )
        VALUES (NEWID(),
                [Source].[DeviceSessionId],
                [Source].[StartTimeUTC],
                [Source].[EndTimeUTC],
                [Source].[SampleRate],
                [Source].[WaveformData],
                [Source].[ChannelCode],
                [Source].[CdiLabel]
               );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies waveform data relating to ET alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PM_CopyETWaveformData';

