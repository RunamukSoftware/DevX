CREATE PROCEDURE [dbo].[p_Purge_Input_Rate]
AS
BEGIN
    DECLARE
        @MR AS INT,
        @WF AS INT,
        @TL AS INT,
        @AL AS INT,
        @ML AS INT,
        @PJ AS INT,
        @CE AS INT,
        @HS AS INT,
        @HE AS INT,
        @HN AS INT,
        @HP AS INT;

    DECLARE @tmp_io_avg TABLE
        (
         [timeperiod] VARCHAR(12),
         [tcount] INT
        );

    -- Monitor results
    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [obs_start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [obs_start_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_result]
    GROUP BY
        (CONVERT(VARCHAR, [obs_start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [obs_start_dt], 8), 1, 2));

    SET @MR = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- Waveform 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [start_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_waveform]
    GROUP BY
        (CONVERT(VARCHAR, [start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [start_dt], 8), 1, 2));

    SET @WF = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- 12 Lead 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [param_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [param_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_param_timetag]
    GROUP BY
        (CONVERT(VARCHAR, [param_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [param_dt], 8), 1, 2));

    SET @TL = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- Alarm 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [start_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_alarm]
    GROUP BY
        (CONVERT(VARCHAR, [start_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [start_dt], 8), 1, 2));

    SET @AL = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- Message Log
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [msg_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [msg_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_msg_log]
    WHERE
        [external_id] IS NULL
    GROUP BY
        (CONVERT(VARCHAR, [msg_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [msg_dt], 8), 1, 2));

    SET @ML = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- Print Job 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [job_net_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [job_net_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_print_job]
    GROUP BY
        (CONVERT(VARCHAR, [job_net_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [job_net_dt], 8), 1, 2));

    SET @PJ = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- CEI
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [event_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [event_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[int_event_log]
    GROUP BY
        (CONVERT(VARCHAR, [event_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [event_dt], 8), 1, 2));

    SET @CE = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- HL7 Success
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [msg_status] = N'R'
    GROUP BY
        (CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2));

    SET @HS = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- HL7 Error
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [msg_status] = N'E'
    GROUP BY
        (CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2));

    SET @HE = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- HL7 Not read 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [msg_status] = N'N'
    GROUP BY
        (CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2));

    SET @HN = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    -- HL7 Pending 
    DELETE
        @tmp_io_avg;

    INSERT  INTO @tmp_io_avg
    SELECT
        CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2) AS [TIMEPERIOD],
        COUNT(*) AS [TCOUNT]
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [msg_status] = N'P'
    GROUP BY
        (CONVERT(VARCHAR, [sent_dt], 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, [sent_dt], 8), 1, 2));

    SET @HP = (SELECT
                AVG([tcount])
               FROM
                @tmp_io_avg
              );

    SELECT
        @MR AS [MONITORRESULTRATE],
        @WF AS [WAVEFORMRATE],
        @TL AS [TWELVELEADRATE],
        @AL AS [ALARMRATE],
        @ML AS [MESSAGELOGRATE],
        @PJ AS [PRINTJOBRATE],
        @CE AS [CLINICALEVENTRATE],
        @HS AS [HL7SUCCESSRATE],
        @HE AS [HL7ERRORRATE],
        @HN AS [HL7NOTREADRATE],
        @HP AS [HL7PENDINGRATE];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Input_Rate';

