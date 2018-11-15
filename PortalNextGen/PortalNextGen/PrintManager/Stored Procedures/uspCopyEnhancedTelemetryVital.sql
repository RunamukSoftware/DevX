CREATE PROCEDURE [PrintManager].[uspCopyEnhancedTelemetryVital]
AS
    BEGIN
        SET NOCOUNT ON;

        -- The number of minutes to grab vitals data before the start of the alarm... using this instead of tMinusPaddingSeconds for preAlarm in order to match what Clinical Access Alarms Tab does.
        DECLARE @preAlarmDataMinutes INT = 15;

        -- The number of seconds of waveform/vitals data after an alarm that we want to display/capture
        DECLARE @tMinusPaddingSeconds INT;

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

        MERGE [Intesys].[PrintJobEnhancedTelemetryVital] AS [Target]
        USING
            (
                SELECT DISTINCT
                    [ipjea].[PatientID],
                    [vd].[TopicSessionID],
                    [gcm].[GlobalDataSystemCode],
                    [vd].[Name],
                    [vd].[Value],
                    [vd].[Timestamp] AS [ResultDateTime]
                FROM
                    [old].[Vital]                       AS [vd]
                    INNER JOIN
                        [old].[GlobalDataSystemCodeMap] AS [gcm]
                            ON [gcm].[FeedTypeID] = [vd].[FeedTypeID]
                               AND [gcm].[Name] = [vd].[Name]
                    INNER JOIN
                        [old].[TopicSession]            AS [ts]
                            ON [ts].[TopicSessionID] = [vd].[TopicSessionID]
                    INNER JOIN
                        [Intesys].[PrintJobEnhancedTelemetryAlarm]     AS [ipjea]
                            ON [ipjea].[DeviceSessionID] = [ts].[DeviceSessionID]
                WHERE
                    [vd].[Timestamp] >= DATEADD(MINUTE, -@preAlarmDataMinutes, [ipjea].[AlarmStartDateTime])
                    AND [vd].[Timestamp] <= DATEADD(SECOND, @tMinusPaddingSeconds, [ipjea].[AlarmEndDateTime])
            ) AS [Source]
        ON [Target].[TopicSessionID] = [Source].[TopicSessionID]
           AND [Target].[GlobalDataSystemCode] = [Source].[GlobalDataSystemCode]
           AND [Target].[ResultDateTime] = [Source].[ResultDateTime]
        WHEN NOT MATCHED
            THEN INSERT
                     (
                         [PatientID],
                         [TopicSessionID],
                         [GlobalDataSystemCode],
                         [Name],
                         [Value],
                         [ResultDateTime]
                     )
                 VALUES
                     (
                         [Source].[PatientID],
                         [Source].[TopicSessionID],
                         [Source].[GlobalDataSystemCode],
                         [Source].[Name],
                         [Source].[Value],
                         [Source].[ResultDateTime]
                     );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies vitals data related to Enhanced Telemetry (ET) Alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspCopyEnhancedTelemetryVital';

