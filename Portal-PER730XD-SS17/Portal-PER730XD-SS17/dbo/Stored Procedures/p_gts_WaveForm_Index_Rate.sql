CREATE PROCEDURE [dbo].[p_gts_WaveForm_Index_Rate]
    (
     @MinutesTimeSlice AS INT = 15,
     @Save AS CHAR = 'N',
     @referenceTime AS DATETIME = NULL
    )
AS
BEGIN
    DECLARE
        @cutoffdt AS DATETIME,
        @ucutoffdt AS DATETIME,
        @WaveCount AS INT,
        @ActiveWaveformChannels AS INT,
        @basetime AS DATETIME,
        @baseminute AS INT,
        @Wave_Rate_Index AS INT;

    SET DEADLOCK_PRIORITY LOW;

    IF @MinutesTimeSlice IS NULL
        SET @MinutesTimeSlice = 15;

    IF @Save IS NULL
        SET @Save = 'N';
    ELSE
        SET @Save = UPPER(@Save);

    IF @referenceTime IS NULL
    BEGIN
        SET @basetime = DATEADD(HOUR, DATEDIFF(HOUR, 0, GETDATE( )), 0);
        SET @baseminute = FLOOR(DATEPART(MI, GETDATE( )) / @MinutesTimeSlice) * @MinutesTimeSlice;
    END;
    ELSE
    BEGIN
        SET @basetime = DATEADD(HOUR, DATEDIFF(HOUR, 0, @referenceTime), 0);
        SET @baseminute = FLOOR(DATEPART(MI, @referenceTime) / @MinutesTimeSlice) * @MinutesTimeSlice;
    END;

    SET @ucutoffdt = DATEADD(MINUTE, @baseminute, @basetime);
    SET @cutoffdt = DATEADD(MINUTE, -(@MinutesTimeSlice), @ucutoffdt);

    -- Waveform
    SELECT
        @WaveCount = COUNT(*)
    FROM
        [dbo].[int_waveform]
    WHERE
        (([start_dt] >= @cutoffdt)
        AND ([start_dt] < @ucutoffdt)
        );

    SELECT
        @ActiveWaveformChannels = COUNT(*)
    FROM
        [dbo].[int_patient_channel]
        LEFT OUTER JOIN [dbo].[int_monitor] ON [int_patient_channel].[monitor_id] = [int_monitor].[monitor_id]
        INNER JOIN [dbo].[int_channel_type] ON [int_patient_channel].[channel_type_id] = [dbo].[int_channel_type].[channel_type_id]
    WHERE
        [int_patient_channel].[active_sw] = 1
        AND [int_monitor].[monitor_id] IS NOT NULL
        AND [int_channel_type].[type_cd] = 'WAVEFORM';

    IF @ActiveWaveformChannels > 0
        SET @Wave_Rate_Index = (@WaveCount / @ActiveWaveformChannels);
    ELSE
        SET @Wave_Rate_Index = 0;

    IF @Save = 'Y'
    BEGIN
        IF NOT EXISTS ( SELECT
                            [Wave_Rate_Index]
                        FROM
                            [dbo].[gts_waveform_index_rate]
                        WHERE
                            [period_start] = @cutoffdt
                            AND [period_len] = @MinutesTimeSlice )
            INSERT  INTO [dbo].[gts_waveform_index_rate]
                    ([Wave_Rate_Index],
                     [Current_Wavecount],
                     [Active_Waveform],
                     [period_start],
                     [period_len]
                    )
            SELECT
                @Wave_Rate_Index,
                @WaveCount,
                @ActiveWaveformChannels,
                @cutoffdt,
                @MinutesTimeSlice;
    END;

    SELECT
        @Wave_Rate_Index AS [WAVE_RATE_INDEX],
        @WaveCount AS [CURRENT_WAVECOUNT],
        @ActiveWaveformChannels AS [ACTIVE_WAVEFORM],
        @cutoffdt AS [PERIOD_START],
        @MinutesTimeSlice AS [PERIOD_LEN];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_gts_WaveForm_Index_Rate';

