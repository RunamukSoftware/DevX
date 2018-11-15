CREATE PROCEDURE [dbo].[p_HL7_Status]
AS
BEGIN
    DECLARE
        @outbound_sent INT,
        @outbound_toproc INT,
        @outbound_cnt INT,
        @msg VARCHAR(255);

    SELECT
        @outbound_sent = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] IS NOT NULL;

    SELECT
        @outbound_toproc = COUNT(*)
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [sent_dt] IS NULL;

    SELECT
        @outbound_cnt = COUNT(*)
    FROM
        [dbo].[int_outbound_queue]
    WHERE
        [processed_dt] IS NULL;

    PRINT 'Current Date/Time: ' + CONVERT(VARCHAR(50), GETDATE(), 20);

    PRINT '';

    SET @msg = 'Total Outbound Messages Sent: ' + CONVERT(VARCHAR(50), @outbound_sent);

    PRINT @msg;

    SET @msg = 'Total Outbound Messages not sent: ' + CONVERT(VARCHAR(50), @outbound_toproc);

    PRINT @msg;

    SET @msg = 'Total Outbound Results to Process: ' + CONVERT(VARCHAR(50), @outbound_cnt);

    PRINT @msg;

    PRINT '';

    PRINT 'Last 50 Log Messages';

    SELECT TOP (50)
        [msg_dt],
        [msg_text]
    FROM
        [dbo].[int_msg_log] AS [iml]
    ORDER BY
        [msg_dt] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_HL7_Status';

