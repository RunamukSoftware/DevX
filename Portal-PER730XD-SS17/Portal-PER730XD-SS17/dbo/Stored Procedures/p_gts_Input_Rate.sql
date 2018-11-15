CREATE PROCEDURE [dbo].[p_gts_Input_Rate]
    (
     @MinutesTimeSlice AS INT = 15,
     @Save AS CHAR = 'N',
     @referenceTime AS DATETIME = NULL
    )
AS
BEGIN
    SET DEADLOCK_PRIORITY LOW;

    DECLARE
        @cutoffdt AS DATETIME,
        @ucutoffdt AS DATETIME,
        @basetime AS DATETIME,
        @baseminute AS INT,
        @count AS INT;

    DECLARE @inprate TABLE
        (
         [input_type] VARCHAR(20),
         [period_start] DATETIME NOT NULL,
         [period_len] INT NOT NULL,
         [rate_counter] INT NOT NULL
        );

    IF @MinutesTimeSlice IS NULL
        SET @MinutesTimeSlice = 15;

    IF @Save IS NULL
        SET @Save = 'N';
    ELSE
        SET @Save = UPPER(@Save);

    IF (@referenceTime IS NULL)
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

    -- Monitor results
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_result]
    WHERE
        [obs_start_dt] >= @cutoffdt
        AND [obs_start_dt] < @ucutoffdt;

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('MonitorResults', @cutoffdt, @MinutesTimeSlice, @count);

    -- Waveform
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_waveform]
    WHERE
        (([start_dt] >= @cutoffdt)
        AND ([start_dt] < @ucutoffdt)
        );

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('WaveFormData', @cutoffdt, @MinutesTimeSlice, @count);

    -- 12 Lead
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_param_timetag]
    WHERE
        (([param_dt] >= @cutoffdt)
        AND ([param_dt] < @ucutoffdt)
        );

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('TwelveLead', @cutoffdt, @MinutesTimeSlice, @count);

    -- Alarm
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_alarm]
    WHERE
        [start_dt] >= @cutoffdt
        AND [start_dt] < @ucutoffdt;

    -- Saves Counter for
    INSERT  INTO @inprate
    VALUES
            ('Alarm', @cutoffdt, @MinutesTimeSlice, @count);

    -- MessageLog
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_msg_log]
    WHERE
        [msg_dt] >= @cutoffdt
        AND [msg_dt] < @ucutoffdt;

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('MsgLog', @cutoffdt, @MinutesTimeSlice, @count);

    -- Print_Job
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_print_job]
    WHERE
        [job_net_dt] >= @cutoffdt
        AND [job_net_dt] < @ucutoffdt;

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('PrintJob', @cutoffdt, @MinutesTimeSlice, @count);

    -- Clinical Event Interface
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[int_event_log]
    WHERE
        [event_dt] >= @cutoffdt
        AND [event_dt] < @ucutoffdt;

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('CEILog', @cutoffdt, @MinutesTimeSlice, @count);

    -- HL7 Success
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] >= @cutoffdt
        AND [sent_dt] < @ucutoffdt
        AND [msg_status] = N'R';

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('HL7Success', @cutoffdt, @MinutesTimeSlice, @count);

    -- HL7 Error
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] >= @cutoffdt
        AND [sent_dt] < @ucutoffdt
        AND [msg_status] = N'E';

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('HL7Error', @cutoffdt, @MinutesTimeSlice, @count);

    -- HL7 Not Read
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] >= @cutoffdt
        AND [sent_dt] < @ucutoffdt
        AND [msg_status] = N'N';

    -- Saves Counter
    INSERT  INTO @inprate
    VALUES
            ('HL7NotRead', @cutoffdt, @MinutesTimeSlice, @count);

    -- HL7 Pending
    SELECT
        @count = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] >= @cutoffdt
        AND [sent_dt] < @ucutoffdt
        AND [msg_status] = N'P';

    INSERT  INTO @inprate
    VALUES
            ('HL7Pending', @cutoffdt, @MinutesTimeSlice, @count);

    -- Saves Counter
    IF (@Save = 'Y')
    BEGIN
        IF NOT EXISTS ( SELECT TOP 1
                            [period_len]
                        FROM
                            [dbo].[gts_input_rate]
                        WHERE
                            [period_start] = @cutoffdt
                            AND [period_len] = @MinutesTimeSlice )
            INSERT  INTO [dbo].[gts_input_rate]
                    ([input_type],
                     [period_start],
                     [period_len],
                     [rate_counter]
                    )
            SELECT
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            FROM
                @inprate;
    END;

    SELECT
        [input_type],
        [period_start],
        [period_len],
        [rate_counter]
    FROM
        @inprate;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_gts_Input_Rate';

