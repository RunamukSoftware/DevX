CREATE PROCEDURE [TechSupport].[uspWaveFormIndexRate]
    (
        @MinutesTimeSlice AS INT          = 15,
        @Save AS             CHAR(1)      = 'N',
        @ReferenceTime AS    DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @CutOffDateTime AS         DATETIME2(7),
            @UpperCutOffDateTime AS    DATETIME2(7),
            @WaveCount AS              INT,
            @ActiveWaveformChannels AS INT,
            @BaseTime AS               DATETIME2(7) = CAST(SYSUTCDATETIME() AS DATE),
            @BaseMinute AS             INT,
            @WaveRateIndex AS          INT;

        IF (@MinutesTimeSlice IS NULL)
            SET @MinutesTimeSlice = 15;

        IF (@Save IS NULL)
            SET @Save = 'N';
        ELSE
            SET @Save = UPPER(@Save);

        SET @BaseTime = CAST(SYSUTCDATETIME() AS DATE);

        IF (@ReferenceTime IS NULL)
            BEGIN
                SET @BaseTime = DATEADD(HOUR, DATEDIFF(HOUR, @BaseTime, SYSUTCDATETIME()), @BaseTime);
                SET @BaseMinute = FLOOR(DATEPART(MINUTE, SYSUTCDATETIME()) / @MinutesTimeSlice) * @MinutesTimeSlice;
            END;
        ELSE
            BEGIN
                SET @BaseTime = DATEADD(HOUR, DATEDIFF(HOUR, @BaseTime, @ReferenceTime), @BaseTime);
                SET @BaseMinute = FLOOR(DATEPART(MINUTE, @ReferenceTime) / @MinutesTimeSlice) * @MinutesTimeSlice;
            END;

        SET @UpperCutOffDateTime = DATEADD(MINUTE, @BaseMinute, @BaseTime);
        SET @CutOffDateTime = DATEADD(MINUTE, - (@MinutesTimeSlice), @UpperCutOffDateTime);

        -- Waveform
        SELECT
            @WaveCount = COUNT(*)
        FROM
            [Intesys].[Waveform] AS [iw]
        WHERE
            [iw].[StartDateTime] >= @CutOffDateTime
            AND [iw].[StartDateTime] < @UpperCutOffDateTime;

        SELECT
            @ActiveWaveformChannels = COUNT(*)
        FROM
            [Intesys].[PatientChannel]  AS [ipc]
            LEFT OUTER JOIN
                [Intesys].[Monitor]     AS [im]
                    ON [ipc].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[ChannelType] AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ipc].[ActiveSwitch] = 1
            AND [im].[MonitorID] IS NOT NULL
            AND [ict].[TypeCode] = 'WAVEFORM';

        IF (@ActiveWaveformChannels > 0)
            SET @WaveRateIndex = (@WaveCount / @ActiveWaveformChannels);
        ELSE
            SET @WaveRateIndex = 0;

        IF (@Save = 'Y')
            BEGIN
                IF NOT EXISTS
                    (
                        SELECT
                            [gwir].[WaveformRateIndex]
                        FROM
                            [TechSupport].[WaveformIndexRate] AS [gwir]
                        WHERE
                            [gwir].[PeriodStartDateTime] = @CutOffDateTime
                            AND [gwir].[PeriodLength] = @MinutesTimeSlice
                    )
                    INSERT INTO [TechSupport].[WaveformIndexRate]
                        (
                            [WaveformRateIndex],
                            [CurrentWaveformCount],
                            [ActiveWaveform],
                            [PeriodStartDateTime],
                            [PeriodLength]
                        )
                                SELECT
                                    @WaveRateIndex,
                                    @WaveCount,
                                    @ActiveWaveformChannels,
                                    @CutOffDateTime,
                                    @MinutesTimeSlice;
            END;

        SELECT
            @WaveRateIndex          AS [WAVE_RATE_INDEX],
            @WaveCount              AS [CURRENT_WAVECOUNT],
            @ActiveWaveformChannels AS [ACTIVE_WAVEFORM],
            @CutOffDateTime         AS [PERIOD_START],
            @MinutesTimeSlice       AS [PERIOD_LEN];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'PROCEDURE', @level1name = N'uspWaveFormIndexRate';

