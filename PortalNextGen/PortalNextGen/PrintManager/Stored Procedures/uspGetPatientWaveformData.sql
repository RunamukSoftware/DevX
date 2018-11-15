CREATE PROCEDURE [PrintManager].[uspGetPatientWaveformData]
    (
        @AlarmID         INT,
        @NumberOfSeconds INT      = -1,
        @Locale          NCHAR(2) = N'en'
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @DeviceSessionID INT;
        DECLARE @AlarmStartTimeUTC DATETIME2(7);
        DECLARE @AlarmEndTimeUTC DATETIME2(7);
        DECLARE @PaddingSeconds INT = 6; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture
        DECLARE @LatestSample DATETIME2(7);

        CREATE TABLE [#Waveforms]
            (
                [ReportStartDateTime]   DATETIME2(7),
                [ReportEndDateTime]     DATETIME2(7),
                [WaveformStartDateTime] DATETIME2(7),
                [WaveformEndDateTime]   DATETIME2(7),
                [SampleRate]            INT,
                [WaveformData]          VARBINARY(MAX),
                [ChannelCode]           INT,
                [WaveformLabel]         NVARCHAR(250),
                [Compressed]            INT
            );

        IF (
               @Locale IS NULL
               OR @Locale NOT IN (
                                     N'de', N'en', N'es', N'fr', N'it', N'nl', N'pl', N'zh', N'cs', N'pt'
                                 )
           )
            SET @Locale = N'en';

        SELECT
            @DeviceSessionID   = [DeviceSessionID],
            @AlarmStartTimeUTC = DATEADD(SECOND, -@PaddingSeconds, [AlarmStartDateTime]),
            @AlarmEndTimeUTC   = DATEADD(SECOND, @PaddingSeconds, [AlarmEndDateTime])
        FROM
            [Intesys].[PrintJobEnhancedTelemetryAlarm]
        WHERE
            [AlarmID] = @AlarmID;

        IF (@NumberOfSeconds > 0)
            SET @AlarmEndTimeUTC = DATEADD(SECOND, @NumberOfSeconds, @AlarmStartTimeUTC);

        IF (@AlarmEndTimeUTC IS NULL)
            SET @AlarmEndTimeUTC = GETUTCDATE();

        INSERT INTO [#Waveforms]
            (
                [ReportStartDateTime],
                [ReportEndDateTime],
                [WaveformStartDateTime],
                [WaveformEndDateTime],
                [SampleRate],
                [WaveformData],
                [ChannelCode],
                [WaveformLabel],
                [Compressed]
            )
                    SELECT DISTINCT
                            @AlarmStartTimeUTC,
                            @AlarmEndTimeUTC,
                            [Waveforms].[StartDateTime],
                            [Waveforms].[EndDateTime],
                            [Waveforms].[SampleRate],
                            [Waveforms].[WaveformData],
                            [Waveforms].[ChannelCode],
                            [rs].[Value],
                            [Waveforms].[Compressed]
                    FROM
                            (
                                SELECT
                                    [ipjew].[StartDateTime],
                                    [ipjew].[EndDateTime],
                                    [ipjew].[SampleRate],
                                    [ipjew].[WaveformData],
                                    [ipjew].[ChannelCode],
                                    [ipjew].[CdiLabel],
                                    1 AS [Compressed]
                                FROM
                                    [Intesys].[PrintJobEnhancedTelemetryWaveform] AS [ipjew]
                                WHERE
                                    [ipjew].[DeviceSessionID] = @DeviceSessionID
                                    AND [ipjew].[StartDateTime] < @AlarmEndTimeUTC
                                UNION ALL
                                SELECT
                                        [wl].[StartDateTime],
                                        [wl].[EndDateTime],
                                        [tft].[SampleRate],
                                        [wl].[Samples] AS [WaveformData],
                                        [tft].[ChannelCode],
                                        [tft].[Label]  AS [CdiLabel],
                                        [wl].[Compressed]
                                FROM
                                        [old].[Waveform]     AS [wl]
                                    INNER JOIN
                                        [old].[TopicSession] AS [ts]
                                            ON [wl].[TopicSessionID] = [ts].[TopicSessionID]
                                    INNER JOIN
                                        [old].[FeedType]     AS [tft]
                                            ON [tft].[FeedTypeID] = [wl].[TypeID]
                                WHERE
                                        [ts].[DeviceSessionID] = @DeviceSessionID
                                        AND [wl].[StartDateTime] < @AlarmEndTimeUTC
                            )                      AS [Waveforms]
                        INNER JOIN
                            [old].[ResourceString] AS [rs]
                                ON [Waveforms].[CdiLabel] = [rs].[Name]
                                   AND [rs].[Locale] = @Locale
                    WHERE
                            [Waveforms].[EndDateTime] > @AlarmStartTimeUTC;

        SELECT
            @LatestSample = MAX([WaveformEndDateTime])
        FROM
            [#Waveforms];

        IF (@AlarmEndTimeUTC > @LatestSample)
            BEGIN
                INSERT INTO [#Waveforms]
                    (
                        [ReportStartDateTime],
                        [ReportEndDateTime],
                        [WaveformStartDateTime],
                        [WaveformEndDateTime],
                        [SampleRate],
                        [WaveformData],
                        [ChannelCode],
                        [WaveformLabel],
                        [Compressed]
                    )
                            SELECT DISTINCT
                                    @AlarmStartTimeUTC          AS [ReportStartDateTime],
                                    @AlarmEndTimeUTC            AS [ReportEndDateTime],
                                    [Waveforms].[StartDateTime] AS [WaveformStartDateTime],
                                    [Waveforms].[EndDateTime]   AS [WaveformEndDateTime],
                                    [Waveforms].[SampleRate],
                                    [Waveforms].[WaveformData],
                                    [Waveforms].[ChannelCode],
                                    [rs].[Value]                AS [WaveformLabel],
                                    [Waveforms].[Compressed]
                            FROM
                                    (
                                        SELECT
                                                [ts].[DeviceSessionID],
                                                [wl].[StartDateTime],
                                                [wl].[EndDateTime],
                                                [tft].[SampleRate],
                                                [wl].[Samples] AS [WaveformData],
                                                [tft].[ChannelCode],
                                                [tft].[Label]  AS [CdiLabel],
                                                0              AS [Compressed]
                                        FROM
                                                [old].[WaveformLive] AS [wl]
                                            INNER JOIN
                                                [old].[TopicSession] AS [ts]
                                                    ON [wl].[TopicInstanceID] = [ts].[TopicInstanceID]
                                            INNER JOIN
                                                [old].[FeedType]     AS [tft]
                                                    ON [tft].[FeedTypeID] = [wl].[TypeID]
                                        WHERE
                                                [ts].[DeviceSessionID] = @DeviceSessionID
                                                AND [wl].[StartDateTime] < @AlarmEndTimeUTC
                                    )                      AS [Waveforms]
                                INNER JOIN
                                    [old].[ResourceString] AS [rs]
                                        ON [Waveforms].[CdiLabel] = [rs].[Name]
                                           AND [rs].[Locale] = @Locale
                            WHERE
                                    [Waveforms].[EndDateTime] > @LatestSample;
            END;

        SELECT
            [ReportStartDateTime],
            [ReportEndDateTime],
            [WaveformStartDateTime],
            [WaveformEndDateTime],
            [SampleRate],
            [WaveformData],
            [ChannelCode],
            [WaveformLabel],
            [Compressed]
        FROM
            [#Waveforms]
        ORDER BY
            [ChannelCode],
            [WaveformStartDateTime] ASC;

        DROP TABLE [#Waveforms];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'PrintManager', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientWaveformData';

