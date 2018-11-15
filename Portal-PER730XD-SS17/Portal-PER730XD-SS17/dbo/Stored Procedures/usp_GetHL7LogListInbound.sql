CREATE PROCEDURE [dbo].[usp_GetHL7LogListInbound]
    (
     @FromDate NVARCHAR(MAX),
     @ToDate NVARCHAR(MAX),
     @MessageNumber NVARCHAR(40) = NULL,
     @PatientId NVARCHAR(40) = NULL,
     @MsgEventCode NCHAR(6) = NULL,
     @MsgEventType NCHAR(6) = NULL,
     @MsgSystem NVARCHAR(100) = NULL,
     @PatientVisitNo NVARCHAR(40) = NULL,
     @MsgStatusRead BIT,
     @MsgStatusError BIT,
     @MsgStatusNotProcessed BIT
    )
AS
BEGIN
    DECLARE
        @ADTQuery NVARCHAR(MAX),
        @SubQuery NVARCHAR(200);
    SET @ADTQuery = N'
        SELECT 
            MessageQueuedDate AS Date,
            HL7InboundMessage.MessageControlId AS HL7#, 
            HL7PatientLink.PatientMrn AS ''Patient ID'',
            MessageStatus AS ''Status'', 
            MessageSendingApplication AS ''Send System'', 
            MessageTypeEventCode AS Event,
            HL7Message AS Message,
            ''I'' AS Direction 
        FROM dbo.HL7InboundMessage
            LEFT OUTER JOIN dbo.HL7PatientLink
                ON HL7PatientLink.MessageNo=HL7InboundMessage.MessageNo
        WHERE MessageQueuedDate BETWEEN ';

    SET @ADTQuery += N'''' + @FromDate + '''';

    SET @ADTQuery += N' AND ';

    SET @ADTQuery += N'''' + @ToDate + N'''';

    IF (@MessageNumber IS NOT NULL
        AND @MessageNumber <> N''
        )
        SET @ADTQuery += N' AND  HL7InboundMessage.MessageControlId=' + N'''' + @MessageNumber + N'''';

    IF (@PatientId IS NOT NULL
        AND @PatientId <> N''
        )
        SET @ADTQuery += N' AND  HL7PatientLink.PatientMrn=' + N'''' + @PatientId + N'''';

    IF (@MsgEventCode IS NOT NULL
        AND @MsgEventCode <> N''
        )
        SET @ADTQuery += N' AND  HL7InboundMessage.MessageTypeEventCode=' + N'''' + @MsgEventCode + N'''';

    IF (@MsgEventType IS NOT NULL
        AND @MsgEventType <> N''
        )
        SET @ADTQuery += N' AND  HL7InboundMessage.MessageType=' + N'''' + @MsgEventType + N'''';

    IF (@MsgSystem IS NOT NULL
        AND @MsgSystem <> ''
        )
        SET @ADTQuery += N' AND  HL7InboundMessage.MessageSendingApplication=' + N'''' + @MsgSystem + N'''';

    IF (@PatientVisitNo IS NOT NULL
        AND @PatientVisitNo <> ''
        )
        SET @ADTQuery += N' AND  HL7PatientLink.PatientVisitNumber=' + N'''' + @PatientVisitNo + N'''';

    IF (@MsgStatusRead = 1
        OR @MsgStatusError = 1
        OR @MsgStatusNotProcessed = 1
        )
    BEGIN
        SET @ADTQuery += N' AND ';
        SET @SubQuery = '(';

        IF (@MsgStatusRead = 1)
        BEGIN
            SET @SubQuery += N' HL7InboundMessage.MessageStatus=''R'' ';
        END;

        IF (@MsgStatusError = 1)
        BEGIN
            IF (LEN(@SubQuery) > 1)
                SET @SubQuery += N' OR ';
            SET @SubQuery += N' HL7InboundMessage.MessageStatus=''E'' ';
        END;

        IF (@MsgStatusNotProcessed = 1)
        BEGIN
            IF (LEN(@SubQuery) > 1)
                SET @SubQuery += N' OR ';
            SET @SubQuery += N' HL7InboundMessage.MessageStatus=''N'' ';
        END;

        SET @SubQuery += N')';
        SET @ADTQuery += @SubQuery;
    END;

    EXEC(@ADTQuery);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetHL7LogListInbound';

