CREATE PROCEDURE [dbo].[usp_PM_CopyETVitalsData]
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
        [dbo].[ApplicationSettings]
    WHERE
        [ApplicationType] = 'Global'
        AND [Key] = 'PrintJobPaddingSeconds';

    IF @tMinusPaddingSeconds IS NULL
        RAISERROR(N'Global setting "%s" from the ApplicationSettings table was null or missing', 13, 1, N'PrintJobPaddingSeconds');

    MERGE [dbo].[int_print_job_et_vitals] AS [Target]
    USING
        (SELECT DISTINCT
            [ipjea].[PatientId],
            [vd].[TopicSessionId],
            [gcm].[GdsCode] AS [GDSCode],
            [vd].[Name],
            [vd].[Value] AS [Value],
            [vd].[TimestampUTC] AS [ResultTimeUTC]
         FROM
            [dbo].[VitalsData] AS [vd]
            INNER JOIN [dbo].[GdsCodeMap] AS [gcm]
                ON [gcm].[FeedTypeId] = [vd].[FeedTypeId]
                   AND [gcm].[Name] = [vd].[Name]
            INNER JOIN [dbo].[TopicSessions] AS [ts]
                ON [ts].[Id] = [vd].[TopicSessionId]
            INNER JOIN [dbo].[int_print_job_et_alarm] AS [ipjea]
                ON [ipjea].[DeviceSessionId] = [ts].[DeviceSessionId]
         WHERE
            [vd].[TimestampUTC] >= DATEADD(MINUTE, -@preAlarmDataMinutes, [ipjea].[AlarmStartTimeUTC])
            AND [vd].[TimestampUTC] <= DATEADD(SECOND, @tMinusPaddingSeconds, [ipjea].[AlarmEndTimeUTC])
        ) AS [Source]
    ON [Target].[TopicSessionId] = [Source].[TopicSessionId]
        AND [Target].[GDSCode] = [Source].[GDSCode]
        AND [Target].[ResultTimeUTC] = [Source].[ResultTimeUTC]
    WHEN NOT MATCHED THEN
        INSERT
               ([Id],
                [PatientId],
                [TopicSessionId],
                [GDSCode],
                [Name],
                [Value],
                [ResultTimeUTC])
        VALUES (NEWID(),
                [Source].[PatientId],
                [Source].[TopicSessionId],
                [Source].[GDSCode],
                [Source].[Name],
                [Source].[Value],
                [Source].[ResultTimeUTC]);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Copies vitals data related to ET Alarms for printing and reprinting. Used by the ICS_PrintJobDataCopier SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PM_CopyETVitalsData';

