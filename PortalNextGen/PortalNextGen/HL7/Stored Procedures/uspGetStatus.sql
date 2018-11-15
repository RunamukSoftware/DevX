CREATE PROCEDURE [HL7].[uspGetStatus]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @OutboundSent      INT,
            @OutboundToProcess INT,
            @OutboundCount     INT,
            @Message           VARCHAR(255);

        SELECT
            @OutboundSent = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] IS NOT NULL;

        SELECT
            @OutboundToProcess = COUNT(*)
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[SentDateTime] IS NULL;

        SELECT
            @OutboundCount = COUNT(*)
        FROM
            [Intesys].[OutboundQueue] AS [oq]
        WHERE
            [oq].[ProcessedDateTime] IS NULL;

        PRINT 'Current Date/Time: ' + CONVERT(VARCHAR(50), SYSUTCDATETIME(), 20);

        PRINT '';

        SET @Message = 'Total Outbound Messages Sent: ' + CONVERT(VARCHAR(50), @OutboundSent);
        PRINT @Message;

        SET @Message = 'Total Outbound Messages not sent: ' + CONVERT(VARCHAR(50), @OutboundToProcess);
        PRINT @Message;

        SET @Message = 'Total Outbound Results to Process: ' + CONVERT(VARCHAR(50), @OutboundCount);
        PRINT @Message;

        PRINT '';

        PRINT 'Last 50 Log Messages';

        SELECT TOP (50)
            [iml].[MessageDateTime],
            [iml].[MessageText]
        FROM
            [Intesys].[MessageLog] AS [iml]
        ORDER BY
            [iml].[MessageDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetStatus';

