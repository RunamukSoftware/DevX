CREATE PROCEDURE [PrintManager].[uspGetAlarmData]
    (
        @AlarmID INT,
        @Locale  CHAR(2) = 'en'
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@AlarmID IS NULL)
            RAISERROR(14043, -1, -1, '@AlarmID', 'uspGetAlarmData');

        IF (
               @Locale IS NULL
               OR @Locale NOT IN (
                                     'de', 'en', 'es', 'fr', 'it', 'nl', 'pl', 'zh', 'cs', 'pt'
                                 )
           )
            SET @Locale = 'en';

        DECLARE @paddingSeconds INT; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture

        SELECT
            @paddingSeconds = CAST([Value] AS INT)
        FROM
            [old].[ApplicationSetting]
        WHERE
            [ApplicationType] = 'Global'
            AND [Key] = 'PrintJobPaddingSeconds';

        IF @paddingSeconds IS NULL
            RAISERROR(
                         N'Global setting "%s" from the ApplicationSettings table was null or missing', 13, 1,
                         N'PrintJobPaddingSeconds'
                     );

        SELECT
            [Alarms].[AlarmID],
            [Alarms].[PatientID],
            ISNULL(
                      ISNULL([ResMessage].[Value], '') + '  '
                      + REPLACE(ISNULL([ResValue].[Value], ''), '{0}', [Alarms].[ViolatingValue]) + '  '
                      + REPLACE(ISNULL([ResLimit].[Value], ''), '{0}', [Alarms].[SettingViolated]),
                      [ResMessage].[Value]
                  )                                                         AS [Title],
            DATEADD(SECOND, -@paddingSeconds, [Alarms].[AlarmStartDateTime]) AS [ReportStartDateTime],
            DATEADD(SECOND, @paddingSeconds, [Alarms].[AlarmEndDateTime])    AS [ReportEndDateTime],
            ISNULL([ResLabel].[Value], '')                                  AS [TitleLabel],
            [Alarms].[FirstName],
            [Alarms].[LastName],
            [Alarms].[ID1],
            [Alarms].[ID2],
            [Alarms].[DateOfBirth],
            [Alarms].[FacilityName],
            [Alarms].[UnitName],
            [Alarms].[MonitorName]
        FROM
            [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [Alarms]
            LEFT OUTER JOIN
                [old].[ResourceString]  AS [ResMessage]
                    ON [ResMessage].[Name] = [Alarms].[StrMessage]
                       AND [ResMessage].[Locale] = @Locale
            LEFT OUTER JOIN
                [old].[ResourceString]  AS [ResLimit]
                    ON [ResLimit].[Name] = [Alarms].[StrLimitFormat]
                       AND [ResLimit].[Locale] = @Locale
            LEFT OUTER JOIN
                [old].[ResourceString]  AS [ResValue]
                    ON [ResValue].[Name] = [Alarms].[StrValueFormat]
                       AND [ResValue].[Locale] = @Locale
            LEFT OUTER JOIN
                [old].[ResourceString]  AS [ResLabel]
                    ON [ResLabel].[Name] = [Alarms].[StrTitleLabel]
                       AND [ResLabel].[Locale] = @Locale
        WHERE
            [Alarms].[AlarmID] = @AlarmID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purpose: Retreives alarm data for a given alarm id.  @AlarmID: The alarm id associated with the print job.  @Locale: The two digit locale to translate the descriptions string into.', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspGetAlarmData';

