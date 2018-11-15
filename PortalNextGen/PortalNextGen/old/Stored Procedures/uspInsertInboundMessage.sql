CREATE PROCEDURE [old].[uspInsertInboundMessage]
    (
        @MessageNumber             INT OUTPUT,
        @MessageStatus             CHAR(1),
        @HL7Message                NVARCHAR(MAX),
        @MessageSendingApplication NVARCHAR(180),
        @MessageSendingFacility    NVARCHAR(180),
        @MessageType               NCHAR(3),
        @MessageTypeEventCode      NCHAR(3),
        @MessageControlID          NVARCHAR(20),
        @MessageVersion            NVARCHAR(60),
        @MessageHeaderDate         DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [HL7].[InboundMessage]
            (
                [MessageStatus],
                [HL7Message],
                [MessageSendingApplication],
                [MessageSendingFacility],
                [MessageType],
                [MessageTypeEventCode],
                [MessageControlID],
                [MessageVersion],
                [MessageHeaderDate],
                [MessageQueuedDate]
            )
        VALUES
            (
                @MessageStatus,
                @HL7Message,
                @MessageSendingApplication,
                @MessageSendingFacility,
                @MessageType,
                @MessageTypeEventCode,
                @MessageControlID,
                @MessageVersion,
                @MessageHeaderDate,
                SYSUTCDATETIME()
            );

        SET @MessageNumber = SCOPE_IDENTITY();
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To link the HL7InboundMessage table with HL7 patients.  HL7_InsertInboundMessage is used to insert inbound messages of Type ADT and QRY.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertInboundMessage';

