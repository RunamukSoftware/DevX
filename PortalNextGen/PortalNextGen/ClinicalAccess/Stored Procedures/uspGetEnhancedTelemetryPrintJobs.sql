CREATE PROCEDURE [ClinicalAccess].[uspGetEnhancedTelemetryPrintJobs]
    (
    @PatientID INT,
    @AlarmStartDateTimeMin DATETIME2(7) = NULL,
    @AlarmStartDateTimeMax DATETIME2(7) = NULL,
    @Locale CHAR(2) = 'en')
AS
BEGIN
    SET NOCOUNT ON;

    SET @AlarmStartDateTimeMin = COALESCE(@AlarmStartDateTimeMin, CONVERT(DATETIME2(7), '1753-01-01 00:00:00', 20)); -- default to minimum date time possible
    SET @AlarmStartDateTimeMax = COALESCE(@AlarmStartDateTimeMax, CONVERT(DATETIME2(7), '9999-12-31 23:59:59', 20)); -- default to maximum date time possible

    DECLARE
        @msPerPageConst FLOAT
        = 6000.0,                  -- There are 6 seconds per page. We use ms instead of seconds to overcome inaccuracies in DateDiff due to boundary cross counting.
        @msPerSecond INT = 1000,
        @tMinusPaddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

    SELECT @tMinusPaddingSeconds = CAST([as].[Value] AS INT)
    FROM [old].[ApplicationSetting] AS [as]
    WHERE [as].[ApplicationType] = 'Global'
          AND [as].[Key] = 'PrintJobPaddingSeconds';

    IF (@Locale IS NULL
        OR @Locale NOT IN ('de', 'en', 'es', 'fr', 'it', 'nl', 'pl', 'zh', 'cs', 'pt'))
        SET @Locale = 'en';

    -- Note: There are two types of alarms, limit alarms and general alarms. The 'description' for a general alarm is just the Alarms.StrMessage. For limit alarms the description is formatted in a 
    -- special way to include information relating to the limits and the actual values... this 'special' format was copied from other stored procedures to be consistent.

    SELECT
        [Alarms].[AlarmID],
        ISNULL(
            ISNULL([ResMessage].[Value], N'') + N'  '
            + REPLACE(ISNULL([ResValue].[Value], N''), N'{0}', [Alarms].[ViolatingValue]) + N'  '
            + REPLACE(ISNULL([ResLimit].[Value], N''), N'{0}', [Alarms].[SettingViolated]),
            [ResMessage].[Value]) AS [Description],
        [Alarms].[AlarmStartDateTime],
        CEILING(
            (DATEDIFF(MILLISECOND,
                      [Alarms].[AlarmStartDateTime],
                      CASE
                          WHEN [Alarms].[AlarmEndDateTime] IS NULL
                              THEN GETUTCDATE()
                          ELSE
                              [Alarms].[AlarmEndDateTime]
                      END) + (2 * (@tMinusPaddingSeconds * @msPerSecond))) / @msPerPageConst) AS [NumberOfPages]
    FROM [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [Alarms]
        LEFT OUTER JOIN [old].[ResourceString] AS [ResMessage]
            ON [ResMessage].[Name] = [Alarms].[StrMessage]
               AND [ResMessage].[Locale] = @Locale
        LEFT OUTER JOIN [old].[ResourceString] AS [ResLimit]
            ON [ResLimit].[Name] = [Alarms].[StrLimitFormat]
               AND [ResLimit].[Locale] = @Locale
        LEFT OUTER JOIN [old].[ResourceString] AS [ResValue]
            ON [ResValue].[Name] = [Alarms].[StrValueFormat]
               AND [ResValue].[Locale] = @Locale
    WHERE [Alarms].[PatientID] = @PatientID
          AND [Alarms].[AlarmStartDateTime] >= @AlarmStartDateTimeMin
          AND [Alarms].[AlarmStartDateTime] <= @AlarmStartDateTimeMax
    ORDER BY [Alarms].[AlarmStartDateTime] DESC;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Returns the Enhanced Telemetry (ET) print alarm job information.  If an unknown or invalid locale is specified, English will be used.  @PatientID: The unique patient identifier to get print jobs associated with.  @AlarmStartDateTimeMin: The minimum/earliest alarm start date time to retrieve (for retrieving alarms in a window/range.)  @AlarmStartDateTimeMax: The maximum/lastest alarm start date time to retrieve (for retrieving alarms in a window/range) in UTC.  @Locale: The two digit locale to translate the descriptions string into.  Returns: [AlarmID]: The unique alarm identifier associated with the print job, [Description]: A localized and formatted alarm description, [AlarmStartDateTime]: The date/time that the alarm was created/started, [NumberOfPages]: The estimated number of pages of this extended telemetry print alarm print report.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryPrintJobs';

