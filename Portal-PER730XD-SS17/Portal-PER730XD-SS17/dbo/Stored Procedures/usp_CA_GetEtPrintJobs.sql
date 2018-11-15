CREATE PROCEDURE [dbo].[usp_CA_GetEtPrintJobs]
    (
     @PatientId UNIQUEIDENTIFIER,
     @alarmStartMinUTC DATETIME = NULL,
     @alarmStartMaxUTC DATETIME = NULL,
     @locale VARCHAR(6) = 'en' -- TG - Should be VARCHAR(6) to accomodate Chinese (zh-CHS)
    )
AS
BEGIN
    SET @alarmStartMinUTC = COALESCE(@alarmStartMinUTC, CONVERT(DATETIME, '1753-01-01 00:00:00', 20)); -- default to minimum date time possible
    SET @alarmStartMaxUTC = COALESCE(@alarmStartMaxUTC, CONVERT(DATETIME, '9999-12-31 23:59:59', 20)); -- default to maximum date time possible

    DECLARE
        @msPerPageConst FLOAT = 6000.0, -- There are 6 seconds per page. We use ms instead of seconds to overcome inaccuracies in DateDiff due to boundary cross counting.
        @msPerSecond INT = 1000,
        @tMinusPaddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

    SELECT
        @tMinusPaddingSeconds = CAST([as].[Value] AS INT)
    FROM
        [dbo].[ApplicationSettings] AS [as]
    WHERE
        [as].[ApplicationType] = 'Global'
        AND [as].[Key] = 'PrintJobPaddingSeconds';

    IF (@locale IS NULL
        OR @locale NOT IN ('de', 'en', 'es', 'fr', 'it', 'nl', 'pl', 'zh-CHS', 'cs', 'pt'))
        SET @locale = 'en';

    -- Note: There are two types of alarms, limit alarms and general alarms. The 'description' for a general alarm is just the Alarms.StrMessage. For limit alarms the description is formatted in a 
    -- special way to include information relating to the limits and the actual values... this 'special' format was copied from other stored procedures to be consistent.

    SELECT
        [Alarms].[AlarmId],
        ISNULL(ISNULL([ResMessage].[Value], N'') + N'  ' + REPLACE(ISNULL([ResValue].[Value], N''), N'{0}',
                                                                   [Alarms].[ViolatingValue]) + N'  '
               + REPLACE(ISNULL([ResLimit].[Value], N''), N'{0}', [Alarms].[SettingViolated]), [ResMessage].[Value]) AS [Description],
        [Alarms].[AlarmStartTimeUTC],
        CEILING((DATEDIFF(ms, [Alarms].[AlarmStartTimeUTC],
                          CASE WHEN [Alarms].[AlarmEndTimeUTC] IS NULL THEN GETUTCDATE()
                               ELSE [Alarms].[AlarmEndTimeUTC]
                          END) + (2 * (@tMinusPaddingSeconds * @msPerSecond))) / @msPerPageConst) AS [NumPages]
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
    WHERE
        [Alarms].[PatientId] = @PatientId
        AND [Alarms].[AlarmStartTimeUTC] >= @alarmStartMinUTC
        AND [Alarms].[AlarmStartTimeUTC] <= @alarmStartMaxUTC
    ORDER BY
        [Alarms].[AlarmStartTimeUTC] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Returns the ET print alarm job information.  If an unknown or invalid locale is specified, English will be used.  @PatientId: The unique patient identifier to get print jobs associated with.  @alarmStartMinUTC: The minimum/earliest alarm start date time to retrieve (for retrieving alarms in a window/range) in UTC.  @alarmStartMaxUTC: The maximum/lastest alarm start date time to retrieve (for retrieving alarms in a window/range) in UTC.  @locale: The two digit locale to translate the descriptions string into.  Returns: [AlarmId]: The unique alarm identifier associated with the print job, [Description]: A localized and formatted alarm description, [AlarmStartTimeUTC]: The date/time that the alarm was created/started in UTC, [NumPages]: The estimated number of pages of this et print alarm print report.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetEtPrintJobs';

