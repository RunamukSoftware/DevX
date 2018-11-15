CREATE PROCEDURE [Purger].[uspDeleteInputRate]
AS
    BEGIN
        SET NOCOUNT ON;

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
                [tcount]     INT
            );

        -- Monitor results
        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [ir].[ObservationStartDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [ir].[ObservationStartDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                                    AS [TCOUNT]
                    FROM
                             [Intesys].[Result] AS [ir]
                    GROUP BY (CONVERT(VARCHAR(30), [ir].[ObservationStartDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [ir].[ObservationStartDateTime], 8), 1, 2)
                             );

        SET @MR =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- Waveform 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [iw].[StartDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [iw].[StartDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [Intesys].[Waveform] AS [iw]
                    GROUP BY (CONVERT(VARCHAR(30), [iw].[StartDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [iw].[StartDateTime], 8), 1, 2)
                             );

        SET @WF =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- 12 Lead 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [ipt].[ParamDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [ipt].[ParamDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                          AS [TCOUNT]
                    FROM
                             [Intesys].[ParameterTimeTag] AS [ipt]
                    GROUP BY (CONVERT(VARCHAR(30), [ipt].[ParamDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [ipt].[ParamDateTime], 8), 1, 2)
                             );

        SET @TL =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- Alarm 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [ia].[StartDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [ia].[StartDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [Intesys].[Alarm] AS [ia]
                    GROUP BY (CONVERT(VARCHAR(30), [ia].[StartDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [ia].[StartDateTime], 8), 1, 2)
                             );

        SET @AL =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- Message Log
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [iml].[MessageDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [iml].[MessageDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                            AS [TCOUNT]
                    FROM
                             [Intesys].[MessageLog] AS [iml]
                    WHERE
                             [iml].[ExternalID] IS NULL
                    GROUP BY (CONVERT(VARCHAR(30), [iml].[MessageDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [iml].[MessageDateTime], 8), 1, 2)
                             );

        SET @ML =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- Print Job 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [ipj].[JobNetDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [ipj].[JobNetDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                           AS [TCOUNT]
                    FROM
                             [Intesys].[PrintJob] AS [ipj]
                    GROUP BY (CONVERT(VARCHAR(30), [ipj].[JobNetDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [ipj].[JobNetDateTime], 8), 1, 2)
                             );

        SET @PJ =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- CEI
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [iel].[EventDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [iel].[EventDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                          AS [TCOUNT]
                    FROM
                             [Intesys].[EventLog] AS [iel]
                    GROUP BY (CONVERT(VARCHAR(30), [iel].[EventDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [iel].[EventDateTime], 8), 1, 2)
                             );

        SET @CE =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- HL7 Success
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [HL7].[OutputQueue] AS [hoq]
                    WHERE
                             [hoq].[MessageStatus] = 'R'
                    GROUP BY (CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2)
                             );

        SET @HS =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- HL7 Error
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [HL7].[OutputQueue] AS [hoq]
                    WHERE
                             [hoq].[MessageStatus] = 'E'
                    GROUP BY (CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2)
                             );

        SET @HE =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- HL7 Not read 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [HL7].[OutputQueue] AS [hoq]
                    WHERE
                             [hoq].[MessageStatus] = 'N'
                    GROUP BY (CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2)
                             );

        SET @HN =
            (
                SELECT
                    AVG([tcount])
                FROM
                    @tmp_io_avg
            );

        -- HL7 Pending 
        DELETE
        @tmp_io_avg;

        INSERT INTO @tmp_io_avg
            (
                [timeperiod],
                [tcount]
            )
                    SELECT
                             CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                             + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2) AS [TIMEPERIOD],
                             COUNT(*)                                                         AS [TCOUNT]
                    FROM
                             [HL7].[OutputQueue] AS [hoq]
                    WHERE
                             [hoq].[MessageStatus] = 'P'
                    GROUP BY (CONVERT(VARCHAR(30), [hoq].[SentDateTime], 2) + ' '
                              + SUBSTRING(CONVERT(VARCHAR(30), [hoq].[SentDateTime], 8), 1, 2)
                             );

        SET @HP =
            (
                SELECT
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteInputRate';

