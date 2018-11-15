CREATE PROCEDURE [Purger].[uspDeleteEvaluation] (@ReferenceDate AS DATETIME2(7))
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @MR AS  INT,
            @WF AS  INT,
            @TL AS  INT,
            @AL AS  INT,
            @ML AS  INT,
            @PJ AS  INT,
            @CE AS  INT,
            @HS AS  INT,
            @HE AS  INT,
            @HN AS  INT,
            @HP AS  INT,
            /* Totals */
            @TMR AS INT,
            @TWF AS INT,
            @TTL AS INT,
            @TAL AS INT,
            @TML AS INT,
            @TPJ AS INT,
            @TCE AS INT,
            @THS AS INT,
            @THE AS INT,
            @THN AS INT,
            @THP AS INT;

        /* Reference date or current date */
        IF (@ReferenceDate IS NULL)
            SET @ReferenceDate = GETDATE();

        /* Int Result */
        SET @MR =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[ObservationStartDateTime] <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'MonitorResults'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TMR =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[Result] AS [ir]
        ) - @MR;

        /* int_waveform */
        SET @WF =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[Waveform] AS [iw]
                WHERE
                    [iw].StartDateTime <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([is].[Setting] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemGeneration] AS [is]
                                    WHERE
                                        [is].[ProductCode] = 'fulldiscl'
                                        AND [is].[FeatureCode] = 'NUMBER_OF_HOURS'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TWF =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[Waveform] AS [iw]
        ) - @WF;

        /* 12Lead */
        SET @TL =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[ParameterTimeTag] AS [ipt]
                WHERE
                    [ipt].[ParamDateTime] <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'TwelveLead'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TTL =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[ParameterTimeTag]
        ) - @TL;

        /* alarm */
        SET @AL =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[Alarm] AS [ia]
                WHERE
                    [ia].StartDateTime <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'Alarm'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TAL =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[Alarm] AS [ia]
        ) - @AL;

        /* Message log */
        SET @ML =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[MessageLog] AS [iml]
                WHERE
                    [iml].[MessageDateTime] <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'Alarm'
                                ),     @ReferenceDate
                                   )
                    )
                    AND [iml].[ExternalID] IS NULL
            );

        SET @TML =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[MessageLog] AS [iml]
            WHERE
                [iml].[ExternalID] IS NULL
        ) - @ML;

        /* Print Job Data */
        SET @PJ =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[PrintJob] AS [ipj]
                WHERE
                    [ipj].[JobNetDateTime] <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'PrintJob'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TPJ =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[PrintJob] AS [ipj]
        ) - @PJ;

        /* CEI */
        SET @CE =
            (
                SELECT
                    COUNT(*)
                FROM
                    [Intesys].[EventLog] AS [iel]
                WHERE
                    [iel].[EventDateTime] <
                    (
                        SELECT
                            DATEADD(   HOUR,
                                (
                                    SELECT
                                        CAST([isp].[ParameterValue] AS INT) * -1
                                    FROM
                                        [Intesys].[SystemParameter] AS [isp]
                                    WHERE
                                        [isp].[ActiveFlag] = 1
                                        AND [isp].[Name] = N'CEILog'
                                ),     @ReferenceDate
                                   )
                    )
            );

        SET @TCE =
        (
            SELECT
                COUNT(*)
            FROM
                [Intesys].[EventLog] AS [iel]
        ) - @CE;

        /* HL7 Success*/
        SET @HS =
            (
                SELECT
                    COUNT(*)
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageStatus] = 'R'
                    AND [hoq].[SentDateTime] <
                        (
                            SELECT
                                DATEADD(   HOUR,
                                    (
                                        SELECT
                                            CAST([isp].[ParameterValue] AS INT) * -1
                                        FROM
                                            [Intesys].[SystemParameter] AS [isp]
                                        WHERE
                                            [isp].[ActiveFlag] = 1
                                            AND [isp].[Name] = N'HL7Success'
                                    ),     @ReferenceDate
                                       )
                        )
            );

        SET @THS =
        (
            SELECT
                COUNT(*)
            FROM
                [HL7].[OutputQueue] AS [hoq]
            WHERE
                [hoq].[MessageStatus] = 'R'
        ) - @HS;

        /* HL7 Error */
        SET @HE =
            (
                SELECT
                    COUNT(*)
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageStatus] = 'E'
                    AND [hoq].[SentDateTime] <
                        (
                            SELECT
                                DATEADD(   HOUR,
                                    (
                                        SELECT
                                            CAST([isp].[ParameterValue] AS INT) * -1
                                        FROM
                                            [Intesys].[SystemParameter] AS [isp]
                                        WHERE
                                            [isp].[ActiveFlag] = 1
                                            AND [isp].[Name] = N'HL7Error'
                                    ),     @ReferenceDate
                                       )
                        )
            );

        SET @THE =
        (
            SELECT
                COUNT(*)
            FROM
                [HL7].[OutputQueue] AS [hoq]
            WHERE
                [hoq].[MessageStatus] = 'E'
        ) - @HE;

        /* HL7 Not Read*/
        SET @HN =
            (
                SELECT
                    COUNT(*)
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageStatus] = 'N'
                    AND [hoq].[SentDateTime] <
                        (
                            SELECT
                                DATEADD(   HOUR,
                                    (
                                        SELECT
                                            CAST([isp].[ParameterValue] AS INT) * -1
                                        FROM
                                            [Intesys].[SystemParameter] AS [isp]
                                        WHERE
                                            [isp].[ActiveFlag] = 1
                                            AND [isp].[Name] = N'HL7NotRead'
                                    ),     @ReferenceDate
                                       )
                        )
            );

        SET @THN =
        (
            SELECT
                COUNT(*)
            FROM
                [HL7].[OutputQueue] AS [hoq]
            WHERE
                [hoq].[MessageStatus] = 'N'
        ) - @HN;

        /* HL7 Pending */
        SET @HP =
            (
                SELECT
                    COUNT(*)
                FROM
                    [HL7].[OutputQueue] AS [hoq]
                WHERE
                    [hoq].[MessageStatus] = 'P'
                    AND [hoq].[SentDateTime] <
                        (
                            SELECT
                                DATEADD(   HOUR,
                                    (
                                        SELECT
                                            CAST([isp].[ParameterValue] AS INT) * -1
                                        FROM
                                            [Intesys].[SystemParameter] AS [isp]
                                        WHERE
                                            [isp].[ActiveFlag] = 1
                                            AND [isp].[Name] = N'HL7Pending'
                                    ),     @ReferenceDate
                                       )
                        )
            );

        SET @THP =
        (
            SELECT
                COUNT(*)
            FROM
                [HL7].[OutputQueue] AS [hoq]
            WHERE
                [hoq].[MessageStatus] = 'P'
        ) - @HP;

        /* inform Results */
        SELECT
            @TMR AS [VALIDMONITORRESULT],
            @MR  AS [EXPMONITORRESULT],
            @TWF AS [VALIDEXPWAVEFORM],
            @WF  AS [EXPWAVEFORM],
            @TTL AS [VALIDTWELVELEAD],
            @TL  AS [EXPTWELVELEAD],
            @TAL AS [VALIDALARM],
            @AL  AS [EXPALARM],
            @TML AS [VALIDMESSAGELOG],
            @ML  AS [EXPMESSAGELOG],
            @TPJ AS [VALIDPRINTJOB],
            @PJ  AS [EXPPRINTJOB],
            @TCE AS [VALIDCEI],
            @CE  AS [EXPCEI],
            @THS AS [VALIDHL7SUCCESS],
            @HS  AS [EXPHL7SUCCESS],
            @THE AS [VALIDHL7ERROR],
            @HE  AS [EXPHL7ERROR],
            @THN AS [VALIDHL7NOTREAD],
            @HN  AS [EXPHL7NOTREAD],
            @THP AS [VALIDHL7NOTREAD],
            @HP  AS [EXPHL7NOTREAD];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteEvaluation';

