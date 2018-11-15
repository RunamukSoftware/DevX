CREATE PROCEDURE [HL7].[uspGetHL7LogListBoth]
    (
        @FromDate              NVARCHAR(MAX),
        @ToDate                NVARCHAR(MAX),
        @MessageNumber         NVARCHAR(40)  = NULL,
        @PatientID             NVARCHAR(40)  = NULL,
        @MsgEventCode          NCHAR(6)      = NULL,
        @MsgEventType          NCHAR(6)      = NULL,
        @MsgSystem             NVARCHAR(100) = NULL,
        @PatientVisitNo        NVARCHAR(40)  = NULL,
        @MsgStatusRead         BIT,
        @MsgStatusError        BIT,
        @MsgStatusNotProcessed BIT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @ADTQuery    NVARCHAR(MAX),
            @SubQuery    NVARCHAR(MAX),
            @OruQuery    NVARCHAR(MAX),
            @SubQueryORU NVARCHAR(MAX);

        SET @ADTQuery
            = N'
        SELECT 
            MessageQueuedDate AS [Date],
            HL7InboundMessage.MessageControlID AS [HL7#], 
            HL7PatientLink.PatientMedicalRecordNumber AS [Patient ID],
            MessageStatus AS [Status], 
            MessageSendingApplication AS [Send System], 
            MessageTypeEventCode AS [Event],
            HL7Message AS [Message],
            ''I'' AS [Direction] 
        FROM dbo.HL7InboundMessage
            LEFT OUTER JOIN dbo.HL7PatientLink
                ON HL7PatientLink.MessageNumber = HL7InboundMessage.MessageNumber
        WHERE MessageQueuedDate BETWEEN ';
        SET @ADTQuery += N'''' + @FromDate + N'''';
        SET @ADTQuery += N' AND ';
        SET @ADTQuery += N'''' + @ToDate + N'''';

        IF (
               @MessageNumber IS NOT NULL
               AND @MessageNumber <> ''
           )
            SET @ADTQuery += N' AND  HL7InboundMessage.MessageControlID=' + N'''' + @MessageNumber + N'''';

        IF (
               @PatientID IS NOT NULL
               AND @PatientID <> ''
           )
            SET @ADTQuery += N' AND  HL7PatientLink.PatientMedicalRecordNumber=' + N'''' + @PatientID + N'''';

        IF (
               @MsgEventCode IS NOT NULL
               AND @MsgEventCode <> ''
           )
            SET @ADTQuery += N' AND  HL7InboundMessage.MessageTypeEventCode=' + N'''' + @MsgEventCode + N'''';

        IF (
               @MsgEventType IS NOT NULL
               AND @MsgEventType <> ''
           )
            SET @ADTQuery += N' AND  HL7InboundMessage.MessageType=' + N'''' + @MsgEventType + N'''';

        IF (
               @MsgSystem IS NOT NULL
               AND @MsgSystem <> ''
           )
            SET @ADTQuery += N' AND  HL7InboundMessage.MessageSendingApplication=' + N'''' + @MsgSystem + N'''';

        IF (
               @PatientVisitNo IS NOT NULL
               AND @PatientVisitNo <> ''
           )
            SET @ADTQuery += N' AND  HL7PatientLink.PatientVisitNumber=' + N'''' + @PatientVisitNo + N'''';

        IF (
               @MsgStatusRead = 1
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

        SET @ADTQuery += N' UNION ';

        SET @OruQuery
            = N'
        SELECT 
            QueuedDateTime AS Date, 
            MessageNumber AS HL7#, 
            PatientID,
            MessageStatus,
            msh_system AS ''Send System'', 
            MshEventCode AS Event,
            ISNULL(HL7TextShort,
            HL7TextLong) AS Message,
            ''O'' AS Direction
        FROM dbo.HL7_out_queue 
        WHERE QueuedDateTime BETWEEN ';
        SET @OruQuery = @OruQuery + N'''' + @FromDate + N'''';
        SET @OruQuery = @OruQuery + N' AND ';
        SET @OruQuery = @OruQuery + N'''' + @ToDate + N'''';

        IF (
               @MessageNumber IS NOT NULL
               AND @MessageNumber <> ''
           )
            SET @OruQuery = @OruQuery + N' AND  MessageNumber=' + N'''' + @MessageNumber + N'''';

        IF (
               @PatientID IS NOT NULL
               AND @PatientID <> ''
           )
            SET @OruQuery = @OruQuery + N' AND  PatientID=' + N'''' + @PatientID + N'''';

        IF (
               @MsgEventCode IS NOT NULL
               AND @MsgEventCode <> ''
           )
            SET @OruQuery = @OruQuery + N' AND  MshEventCode=' + N'''' + @MsgEventCode + N'''';

        IF (
               @MsgEventType IS NOT NULL
               AND @MsgEventType <> ''
           )
            SET @OruQuery = @OruQuery + N' AND  msh_msg_type=' + N'''' + @MsgEventType + N'''';

        IF (
               @MsgSystem IS NOT NULL
               AND @MsgSystem <> ''
           )
            SET @OruQuery = @OruQuery + N' AND  msh_system=' + N'''' + @MsgSystem + N'''';

        IF (
               @MsgStatusRead = 1
               OR @MsgStatusError = 1
               OR @MsgStatusNotProcessed = 1
           )
            BEGIN
                SET @OruQuery = @OruQuery + N' AND ';
                SET @SubQueryORU = '(';

                IF (@MsgStatusRead = 1)
                    BEGIN
                        SET @SubQueryORU += N' MessageStatus=''R'' ';
                    END;

                IF (@MsgStatusError = 1)
                    BEGIN
                        IF (LEN(@SubQueryORU) > 1)
                            SET @SubQueryORU += N' OR ';
                        SET @SubQueryORU += N' MessageStatus=''E'' ';
                    END;

                IF (@MsgStatusNotProcessed = 1)
                    BEGIN
                        IF (LEN(@SubQueryORU) > 1)
                            SET @SubQueryORU += N' OR ';
                        SET @SubQueryORU += N' MessageStatus=''N'' ';
                    END;

                SET @SubQueryORU += N')';
                SET @OruQuery = @OruQuery + @SubQueryORU;
            END;

        EXEC (@ADTQuery + @OruQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetHL7LogListBoth';

