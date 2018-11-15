CREATE PROCEDURE [dbo].[usp_PM_GetPatientWaveformData]
    (
     @alarmId UNIQUEIDENTIFIER,
     @numberOfSeconds INT = -1,
     @locale VARCHAR(6) = 'en' -- TG - Should be VARCHAR(6) to accomodate Chinese (zh-CHS)
    )
AS
BEGIN
    IF (@locale IS NULL
        OR @locale NOT IN (N'de', N'en', N'es', N'fr', N'it', N'nl', N'pl', N'zh-CHS', N'cs', N'pt')
        )
        SET @locale = N'en';

    DECLARE @deviceSessionId UNIQUEIDENTIFIER;
    DECLARE @alarmStartTimeUTC DATETIME;
    DECLARE @alarmEndTimeUTC DATETIME;

    DECLARE @Waveforms TABLE
        (
         [ReportStartTimeUTC] DATETIME,
         [ReportEndTimeUTC] DATETIME,
         [WaveformStartTimeUTC] DATETIME,
         [WaveformEndTimeUTC] DATETIME,
         [SampleRate] INT,
         [WaveformData] VARBINARY(MAX),
         [ChannelCode] INT,
         [WaveformLabel] NVARCHAR(250),
         [Compressed] INT
        );

    DECLARE @paddingSeconds INT = 6; -- The number of seconds of waveform/vitals data before and after an alarm that we want to display/capture


    SELECT
        @deviceSessionId = [DeviceSessionId],
        @alarmStartTimeUTC = DATEADD(SECOND, -@paddingSeconds, [AlarmStartTimeUTC]),
        @alarmEndTimeUTC = DATEADD(SECOND, @paddingSeconds, [AlarmEndTimeUTC])
    FROM
        [dbo].[int_print_job_et_alarm]
    WHERE
        [AlarmId] = @alarmId;
    
    IF (@numberOfSeconds > 0)
        SET @alarmEndTimeUTC = DATEADD(SECOND, @numberOfSeconds, @alarmStartTimeUTC);

    IF (@alarmEndTimeUTC IS NULL)
        SET @alarmEndTimeUTC = GETUTCDATE();

    INSERT  INTO @Waveforms
    SELECT DISTINCT
        @alarmStartTimeUTC AS [ReportStartTimeUTC],
        @alarmEndTimeUTC AS [ReportEndTimeUTC],
        [Waveforms].[StartTimeUTC] AS [WaveformStartTimeUTC],
        [Waveforms].[EndTimeUTC] AS [WaveformEndTimeUTC],
        [Waveforms].[SampleRate],
        [Waveforms].[WaveformData],
        [Waveforms].[ChannelCode],
        [ResourceStrings].[Value] AS [WaveformLabel],
        [Waveforms].[Compressed]
    FROM
        (SELECT
            [ipjew].[StartTimeUTC],
            [ipjew].[EndTimeUTC],
            [ipjew].[SampleRate],
            [ipjew].[WaveformData],
            [ipjew].[ChannelCode],
            [ipjew].[CdiLabel],
            1 AS [Compressed]
         FROM
            [dbo].[int_print_job_et_waveform] AS [ipjew]
         WHERE
            [DeviceSessionId] = @deviceSessionId
            AND [StartTimeUTC] < @alarmEndTimeUTC
         UNION ALL
         SELECT
            [WaveformData].[StartTimeUTC] AS [StartTimeUTC],
            [WaveformData].[EndTimeUTC] AS [EndTimeUTC],
            [TopicFeedTypes].[SampleRate] AS [SampleRate],
            [WaveformData].[Samples] AS [WaveformData],
            [TopicFeedTypes].[ChannelCode] AS [ChannelCode],
            [TopicFeedTypes].[Label] AS [CdiLabel],
            [WaveformData].[Compressed]
         FROM
            [dbo].[WaveformData]
            INNER JOIN [dbo].[TopicSessions] ON [WaveformData].[TopicSessionId] = [TopicSessions].[Id]
            INNER JOIN [dbo].[TopicFeedTypes] ON [TopicFeedTypes].[FeedTypeId] = [WaveformData].[TypeId]
         WHERE
            [TopicSessions].[DeviceSessionId] = @deviceSessionId
            AND [WaveformData].[StartTimeUTC] < @alarmEndTimeUTC
        ) AS [Waveforms]
        INNER JOIN [dbo].[ResourceStrings] ON [CdiLabel] = [ResourceStrings].[Name]
                                        AND [Locale] = @locale
    WHERE
        [Waveforms].[EndTimeUTC] > @alarmStartTimeUTC;

    DECLARE @LatestSample DATETIME;

    SELECT
        @LatestSample = MAX([WaveformEndTimeUTC])
    FROM
        @Waveforms;

    IF (@alarmEndTimeUTC > @LatestSample)
    BEGIN
        INSERT  INTO @Waveforms
        SELECT DISTINCT
            @alarmStartTimeUTC AS [ReportStartTimeUTC],
            @alarmEndTimeUTC AS [ReportEndTimeUTC],
            [StartTimeUTC] AS [WaveformStartTimeUTC],
            [EndTimeUTC] AS [WaveformEndTimeUTC],
            [SampleRate],
            [WaveformData],
            [ChannelCode],
            [ResourceStrings].[Value] AS [WaveformLabel],
            [Waveforms].[Compressed]
        FROM
            (SELECT
                [TopicSessions].[DeviceSessionId],
                [WaveformLiveData].[StartTimeUTC] AS [StartTimeUTC],
                [WaveformLiveData].[EndTimeUTC] AS [EndTimeUTC],
                [TopicFeedTypes].[SampleRate] AS [SampleRate],
                [WaveformLiveData].[Samples] AS [WaveformData],
                [TopicFeedTypes].[ChannelCode] AS [ChannelCode],
                [TopicFeedTypes].[Label] AS [CdiLabel],
                [Compressed] = 0
             FROM
                [dbo].[WaveformLiveData]
                INNER JOIN [dbo].[TopicSessions] ON [WaveformLiveData].[TopicInstanceId] = [TopicSessions].[TopicInstanceId]
                INNER JOIN [dbo].[TopicFeedTypes] ON [TopicFeedTypes].[FeedTypeId] = [WaveformLiveData].[TypeId]
             WHERE
                [TopicSessions].[DeviceSessionId] = @deviceSessionId
                AND [WaveformLiveData].[StartTimeUTC] < @alarmEndTimeUTC
            ) AS [Waveforms]
            INNER JOIN [dbo].[ResourceStrings] ON [CdiLabel] = [ResourceStrings].[Name]
                                                  AND [Locale] = @locale
        WHERE
            [Waveforms].[EndTimeUTC] > @LatestSample;
    END;

    SELECT
        [ReportStartTimeUTC],
        [ReportEndTimeUTC],
        [WaveformStartTimeUTC],
        [WaveformEndTimeUTC],
        [SampleRate],
        [WaveformData],
        [ChannelCode],
        [WaveformLabel],
        [Compressed]
    FROM
        @Waveforms
    ORDER BY
        [ChannelCode],
        [WaveformStartTimeUTC] ASC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_PM_GetPatientWaveformData';

