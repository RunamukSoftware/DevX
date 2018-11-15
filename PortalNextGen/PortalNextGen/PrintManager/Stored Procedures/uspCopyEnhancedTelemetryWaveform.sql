CREATE PROCEDURE [PrintManager].[uspCopyEnhancedTelemetryWaveform]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @tMinusPaddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

        SELECT
            @tMinusPaddingSeconds = CAST([Value] AS INT)
        FROM
            [old].[ApplicationSetting]
        WHERE
            [ApplicationType] = 'Global'
            AND [Key] = 'PrintJobPaddingSeconds';

        IF @tMinusPaddingSeconds IS NULL
            RAISERROR(
                         N'Global setting "%s" from the ApplicationSettings table was null or missing', 13, 1,
                         N'PrintJobPaddingSeconds'
                     );

        MERGE [Intesys].[PrintJobEnhancedTelemetryWaveform] AS [Target]
        USING
            (
                SELECT DISTINCT
                    [AlarmTopics].[DeviceSessionID],
                    [Waveform].[StartDateTime],
                    [Waveform].[EndDateTime],
                    [Waveform].[SampleRate],
                    [Waveform].[WaveformData],
                    [ChannelTypes].[ChannelCode],
                    [ChannelTypes].[CdiLabel]
                FROM
                    [old].[vwLegacyWaveform]         AS [Waveform]
                    LEFT OUTER JOIN
                        [old].[vwLegacyChannelTypes] AS [ChannelTypes]
                            ON [Waveform].[TypeID] = [ChannelTypes].[TypeID]
                    INNER JOIN
                        (
                            SELECT
                                [ipjea].[DeviceSessionID],
                                MIN([ipjea].[AlarmStartDateTime]) AS [MinAlarmStartDateTime],
                                MAX([ipjea].[AlarmEndDateTime])   AS [MaxAlarmEndDateTime]
                            FROM
                                [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [ipjea]
                                INNER JOIN
                                    [old].[TopicSession]                   AS [ts]
                                        ON [ts].[DeviceSessionID] = [ipjea].[DeviceSessionID]
                            GROUP BY
                                [ipjea].[DeviceSessionID]
                        )                            AS [AlarmTopics]
                            ON [AlarmTopics].[DeviceSessionID] = [Waveform].[DeviceSessionID]
                WHERE
                    [Waveform].[StartDateTime] < DATEADD(
                                                            SECOND, @tMinusPaddingSeconds,
                                                            [AlarmTopics].[MaxAlarmEndDateTime]
                                                        )
                    AND [Waveform].[EndDateTime] > DATEADD(
                                                              SECOND, -@tMinusPaddingSeconds,
                                                              [AlarmTopics].[MinAlarmStartDateTime]
                                                          )
            ) AS [Source]
        ON [Target].[DeviceSessionID] = [Source].[DeviceSessionID]
           AND [Target].[StartDateTime] = [Source].[StartDateTime]
           AND [Target].[EndDateTime] = [Source].[EndDateTime]
           AND [Target].[ChannelCode] = [Source].[ChannelCode]
        WHEN NOT MATCHED
            THEN INSERT
                     (
                         [DeviceSessionID],
                         [StartDateTime],
                         [EndDateTime],
                         [SampleRate],
                         [WaveformData],
                         [ChannelCode],
                         [CdiLabel]
                     )
                 VALUES
                     (
                         [Source].[DeviceSessionID],
                         [Source].[StartDateTime],
                         [Source].[EndDateTime],
                         [Source].[SampleRate],
                         [Source].[WaveformData],
                         [Source].[ChannelCode],
                         [Source].[CdiLabel]
                     );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies waveform data relating to Enhanced Telemetry (ET) alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspCopyEnhancedTelemetryWaveform';

