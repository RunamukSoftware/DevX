CREATE PROCEDURE [TechSupport].[uspInputRate]
    (
        @MinutesTimeSlice INT          = 15,
        @Save             CHAR(1)      = 'N',
        @ReferenceTime    DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @CutOffDateTime      DATETIME2(7),
            @UpperCutOffDateTime DATETIME2(7),
            @BaseTime            DATETIME2(7),
            @BaseMinute          INT,
            @count               INT;

        DECLARE @inprate TABLE
            (
                [input_type]   VARCHAR(20)  NOT NULL,
                [period_start] DATETIME2(7) NOT NULL,
                [period_len]   INT          NOT NULL,
                [rate_counter] INT          NOT NULL
            );

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

        -- Monitor results
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[Result] AS [ir]
        WHERE
            [ir].[ObservationStartDateTime] >= @CutOffDateTime
            AND [ir].[ObservationStartDateTime] < @UpperCutOffDateTime;

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'MonitorResults', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- Waveform
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[Waveform] AS [iw]
        WHERE
            (
                ([iw].[StartDateTime] >= @CutOffDateTime)
                AND ([iw].[StartDateTime] < @UpperCutOffDateTime)
            );

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'WaveFormData', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- 12 Lead
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[ParameterTimeTag] AS [ipt]
        WHERE
            (
                ([ipt].[ParamDateTime] >= @CutOffDateTime)
                AND ([ipt].[ParamDateTime] < @UpperCutOffDateTime)
            );

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'TwelveLead', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- Alarm
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[Alarm] AS [ia]
        WHERE
            [ia].[StartDateTime] >= @CutOffDateTime
            AND [ia].[StartDateTime] < @UpperCutOffDateTime;

        -- Saves Counter for
        INSERT INTO @inprate
        VALUES
            (
                'Alarm', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- MessageLog
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[MessageLog] AS [iml]
        WHERE
            [iml].[MessageDateTime] >= @CutOffDateTime
            AND [iml].[MessageDateTime] < @UpperCutOffDateTime;

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'MsgLog', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- Print_Job
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[PrintJob] AS [ipj]
        WHERE
            [ipj].[JobNetDateTime] >= @CutOffDateTime
            AND [ipj].[JobNetDateTime] < @UpperCutOffDateTime;

        -- Saves Counter
        INSERT INTO @inprate
        VALUES
            (
                'PrintJob', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- Clinical Event Interface
        SELECT
            @count = COUNT(*)
        FROM
            [Intesys].[EventLog] AS [iel]
        WHERE
            [iel].[EventDateTime] >= @CutOffDateTime
            AND [iel].[EventDateTime] < @UpperCutOffDateTime;

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'CEILog', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- HL7 Success
        SELECT
            @count = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] >= @CutOffDateTime
            AND [hoq].[SentDateTime] < @UpperCutOffDateTime
            AND [hoq].[MessageStatus] = 'R';

        -- Saves Counter
        INSERT INTO @inprate
        VALUES
            (
                'HL7Success', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- HL7 Error
        SELECT
            @count = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] >= @CutOffDateTime
            AND [hoq].[SentDateTime] < @UpperCutOffDateTime
            AND [hoq].[MessageStatus] = 'E';

        -- Saves Counter
        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'HL7Error', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- HL7 Not Read
        SELECT
            @count = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] >= @CutOffDateTime
            AND [hoq].[SentDateTime] < @UpperCutOffDateTime
            AND [hoq].[MessageStatus] = 'N';

        -- Saves Counter
        INSERT INTO @inprate
        VALUES
            (
                'HL7NotRead', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- HL7 Pending
        SELECT
            @count = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] >= @CutOffDateTime
            AND [hoq].[SentDateTime] < @UpperCutOffDateTime
            AND [hoq].[MessageStatus] = 'P';

        INSERT INTO @inprate
            (
                [input_type],
                [period_start],
                [period_len],
                [rate_counter]
            )
        VALUES
            (
                'HL7Pending', @CutOffDateTime, @MinutesTimeSlice, @count
            );

        -- Saves Counter
        IF (@Save = 'Y')
            BEGIN
                IF NOT EXISTS
                    (
                        SELECT TOP (1)
                            [gir].[PeriodLength]
                        FROM
                            [TechSupport].[InputRate] AS [gir]
                        WHERE
                            [gir].[PeriodStart] = @CutOffDateTime
                            AND [gir].[PeriodLength] = @MinutesTimeSlice
                    )
                    INSERT INTO [TechSupport].[InputRate]
                        (
                            [InputType],
                            [PeriodStart],
                            [PeriodLength],
                            [RateCounter]
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'PROCEDURE', @level1name = N'uspInputRate';

