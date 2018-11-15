CREATE PROCEDURE [dbo].[usp_PM_GetAlarmData]
    (
     @alarmId UNIQUEIDENTIFIER,
     @locale VARCHAR(6) = 'en' -- TG - Should be VARCHAR(6) to accomodate Chinese (zh-CHS)
    )
AS
BEGIN
    IF (@alarmId IS NULL)
        RAISERROR(14043, -1, -1, '@alarmId', 'usp_PM_GetAlarmData');
        
    IF (@locale IS NULL
        OR @locale NOT IN ('de', 'en', 'es', 'fr', 'it', 'nl', 'pl', 'zh-CHS', 'cs', 'pt'))
        SET @locale = 'en';

    DECLARE @paddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

    SELECT
        @paddingSeconds = CAST([Value] AS INT)
    FROM
        [dbo].[ApplicationSettings]
    WHERE
        [ApplicationType] = 'Global'
        AND [Key] = 'PrintJobPaddingSeconds';

    IF @paddingSeconds IS NULL
        RAISERROR(N'Global setting "%s" from the ApplicationSettings table was null or missing', 13, 1, N'PrintJobPaddingSeconds');

    SELECT
        [Alarms].[AlarmId] AS [Id],
        [Alarms].[PatientId],
        ISNULL(ISNULL([ResMessage].[Value], '') + '  ' + REPLACE(ISNULL([ResValue].[Value], ''), '{0}',
                                                                 [Alarms].[ViolatingValue]) + '  '
               + REPLACE(ISNULL([ResLimit].[Value], ''), '{0}', [Alarms].[SettingViolated]), [ResMessage].[Value]) AS [Title],
        DATEADD(s, -@paddingSeconds, [Alarms].[AlarmStartTimeUTC]) AS [ReportStartTimeUTC],
        DATEADD(s, @paddingSeconds, [Alarms].[AlarmEndTimeUTC]) AS [ReportEndTimeUTC],
        ISNULL([ResLabel].[Value], '') AS [TitleLabel],
        [Alarms].[FirstName],
        [Alarms].[LastName],
        [Alarms].[FullName],
        [Alarms].[ID1],
        [Alarms].[ID2],
        [Alarms].[DOB],
        [Alarms].[FacilityName],
        [Alarms].[UnitName],
        [Alarms].[MonitorName]
    FROM
        [dbo].[int_print_job_et_alarm] AS [Alarms]
        LEFT OUTER JOIN [dbo].[ResourceStrings] AS [ResMessage]
            ON [ResMessage].[Name] = [Alarms].[StrMessage]
               AND [ResMessage].[Locale] = @locale
        LEFT OUTER JOIN [dbo].[ResourceStrings] AS [ResLimit]
            ON [ResLimit].[Name] = [Alarms].[StrLimitFormat]
               AND [ResLimit].[Locale] = @locale
        LEFT OUTER JOIN [dbo].[ResourceStrings] AS [ResValue]
            ON [ResValue].[Name] = [Alarms].[StrValueFormat]
               AND [ResValue].[Locale] = @locale
        LEFT OUTER JOIN [dbo].[ResourceStrings] AS [ResLabel]
            ON [ResLabel].[Name] = [Alarms].[StrTitleLabel]
               AND [ResLabel].[Locale] = @locale
    WHERE
        [Alarms].[AlarmId] = @alarmId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purpose: Retreives alarm data for a given alarm id.  @alarmId: The alarm id associated with the print job.  @locale: The two digit locale to translate the descriptions string into.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PM_GetAlarmData';

