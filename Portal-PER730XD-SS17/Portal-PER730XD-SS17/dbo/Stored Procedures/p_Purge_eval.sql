CREATE PROCEDURE [dbo].[p_Purge_eval]
    (
     @ReferenceDate AS DATETIME
    )
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
        @HP AS INT,
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
    IF @ReferenceDate IS NULL
        SET @ReferenceDate = GETDATE( );

    /* Int Result */
    SET @MR = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_result]
               WHERE
                [obs_start_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'MonitorResults'
                                                  ), @ReferenceDate)
                                 )
              );

    SET @TMR = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_result]
               ) - @MR;

    /* int_waveform */
    SET @WF = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_waveform]
               WHERE
                [start_dt] < (SELECT
                                DATEADD(HOUR, (SELECT
                                                CAST([setting] AS INT) * -1
                                               FROM
                                                [dbo].[int_sysgen]
                                               WHERE
                                                [product_cd] = 'fulldiscl'
                                                AND [feature_cd] = 'NUMBER_OF_HOURS'
                                              ), @ReferenceDate)
                             )
              );

    SET @TWF = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_waveform]
               ) - @WF;

    /* 12Lead */
    SET @TL = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_param_timetag]
               WHERE
                [param_dt] < (SELECT
                                DATEADD(HOUR, (SELECT
                                                CAST([parm_value] AS INT) * -1
                                               FROM
                                                [dbo].[int_system_parameter]
                                               WHERE
                                                [active_flag] = 1
                                                AND [name] = N'TwelveLead'
                                              ), @ReferenceDate)
                             )
              );

    SET @TTL = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_param_timetag]
               ) - @TL;

    /* alarm */
    SET @AL = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_alarm]
               WHERE
                [start_dt] < (SELECT
                                DATEADD(HOUR, (SELECT
                                                CAST([parm_value] AS INT) * -1
                                               FROM
                                                [dbo].[int_system_parameter]
                                               WHERE
                                                [active_flag] = 1
                                                AND [name] = N'Alarm'
                                              ), @ReferenceDate)
                             )
              );

    SET @TAL = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_alarm]
               ) - @AL;

    /* Message log */
    SET @ML = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_msg_log]
               WHERE
                [msg_dt] < (SELECT
                                DATEADD(HOUR, (SELECT
                                                CAST([parm_value] AS INT) * -1
                                               FROM
                                                [dbo].[int_system_parameter]
                                               WHERE
                                                [active_flag] = 1
                                                AND [name] = N'Alarm'
                                              ), @ReferenceDate)
                           )
                AND [external_id] IS NULL
              );

    SET @TML = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_msg_log]
                WHERE
                    [external_id] IS NULL
               ) - @ML;

    /* Print Job Data */
    SET @PJ = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_print_job]
               WHERE
                [job_net_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'PrintJob'
                                                  ), @ReferenceDate)
                               )
              );

    SET @TPJ = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_print_job]
               ) - @PJ;

    /* CEI */
    SET @CE = (SELECT
                COUNT(*)
               FROM
                [dbo].[int_event_log]
               WHERE
                [event_dt] < (SELECT
                                DATEADD(HOUR, (SELECT
                                                CAST([parm_value] AS INT) * -1
                                               FROM
                                                [dbo].[int_system_parameter]
                                               WHERE
                                                [active_flag] = 1
                                                AND [name] = N'CEILog'
                                              ), @ReferenceDate)
                             )
              );

    SET @TCE = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[int_event_log]
               ) - @CE;

    /* HL7 Success*/
    SET @HS = (SELECT
                COUNT(*)
               FROM
                [dbo].[HL7_out_queue]
               WHERE
                [msg_status] = N'R'
                AND [sent_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'HL7Success'
                                                  ), @ReferenceDate)
                                )
              );

    SET @THS = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[HL7_out_queue]
                WHERE
                    [msg_status] = N'R'
               ) - @HS;

    /* HL7 Error */
    SET @HE = (SELECT
                COUNT(*)
               FROM
                [dbo].[HL7_out_queue]
               WHERE
                [msg_status] = N'E'
                AND [sent_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'HL7Error'
                                                  ), @ReferenceDate)
                                )
              );

    SET @THE = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[HL7_out_queue]
                WHERE
                    [msg_status] = N'E'
               ) - @HE;

    /* HL7 Not Read*/
    SET @HN = (SELECT
                COUNT(*)
               FROM
                [dbo].[HL7_out_queue]
               WHERE
                [msg_status] = N'N'
                AND [sent_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'HL7NotRead'
                                                  ), @ReferenceDate)
                                )
              );

    SET @THN = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[HL7_out_queue]
                WHERE
                    [msg_status] = N'N'
               ) - @HN;

    /* HL7 Pending */
    SET @HP = (SELECT
                COUNT(*)
               FROM
                [dbo].[HL7_out_queue]
               WHERE
                [msg_status] = N'P'
                AND [sent_dt] < (SELECT
                                    DATEADD(HOUR, (SELECT
                                                    CAST([parm_value] AS INT) * -1
                                                   FROM
                                                    [dbo].[int_system_parameter]
                                                   WHERE
                                                    [active_flag] = 1
                                                    AND [name] = N'HL7Pending'
                                                  ), @ReferenceDate)
                                )
              );

    SET @THP = (SELECT
                    COUNT(*)
                FROM
                    [dbo].[HL7_out_queue]
                WHERE
                    [msg_status] = N'P'
               ) - @HP;

    /* inform Results */
    SELECT
        @TMR AS [VALIDMONITORRESULT],
        @MR AS [EXPMONITORRESULT],
        @TWF AS [VALIDEXPWAVEFORM],
        @WF AS [EXPWAVEFORM],
        @TTL AS [VALIDTWELVELEAD],
        @TL AS [EXPTWELVELEAD],
        @TAL AS [VALIDALARM],
        @AL AS [EXPALARM],
        @TML AS [VALIDMESSAGELOG],
        @ML AS [EXPMESSAGELOG],
        @TPJ AS [VALIDPRINTJOB],
        @PJ AS [EXPPRINTJOB],
        @TCE AS [VALIDCEI],
        @CE AS [EXPCEI],
        @THS AS [VALIDHL7SUCCESS],
        @HS AS [EXPHL7SUCCESS],
        @THE AS [VALIDHL7ERROR],
        @HE AS [EXPHL7ERROR],
        @THN AS [VALIDHL7NOTREAD],
        @HN AS [EXPHL7NOTREAD],
        @THP AS [VALIDHL7NOTREAD],
        @HP AS [EXPHL7NOTREAD];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_eval';

