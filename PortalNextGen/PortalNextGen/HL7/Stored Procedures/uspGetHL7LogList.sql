CREATE PROCEDURE [HL7].[uspGetHL7LogList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [him].[MessageQueuedDate]         AS [Date],
            [him].[MessageControlID]          AS [HL7#],
            [PatientMedicalRecordNumber],
            [him].[MessageStatus],
            [him].[MessageSendingApplication] AS [Send System],
            [him].[MessageTypeEventCode]      AS [Event],
            [him].[HL7Message]                AS [Message],
            'I'                               AS [Direction]
        FROM
            [HL7].[InboundMessage] AS [him]
            LEFT OUTER JOIN
                [HL7].[PatientLink]
                    ON [PatientLink].[MessageNumber] = [him].[MessageNumber]
        UNION
        SELECT
            [hoq].[QueuedDateTime]                            AS [Date],
            [hoq].[MessageNumber]                             AS [HL7#],
            [hoq].[PatientID]                                 AS [Patient ID],
            [hoq].[MessageStatus]                             AS [Status],
            [hoq].[MshSystem]                                 AS [Send System],
            [hoq].[MshEventCode]                              AS [Event],
            ISNULL([hoq].[ShortText], [hoq].[LongText]) AS [Message],
            'O'                                               AS [Direction]
        FROM
            [HL7].[OutputQueue] AS [hoq];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetHL7LogList';

