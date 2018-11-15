CREATE PROCEDURE [HL7].[uspInsertAcknowledgement]
    (
        @MessageControlID            NVARCHAR(20),
        @MessageStatus               CHAR(1),
        @ClientIP                    NVARCHAR(30),
        @ackMsgControlID             NVARCHAR(20),
        @AcknowledgementSystem       NVARCHAR(50),
        @AcknowledgementOrganization NVARCHAR(50)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [HL7].[MessageAcknowledgement]
            (
                [MessageControlID],
                [MessageStatus],
                [ClientIP],
                [AcknowledgementMessageControlID],
                [AcknowledgementSystem],
                [AcknowledgementOrganization],
                [ReceivedDateTime],
                [NumberOfRetries]
            )
        VALUES
            (
                @MessageControlID, @MessageStatus, @ClientIP, @ackMsgControlID, @AcknowledgementSystem,
                @AcknowledgementOrganization, SYSUTCDATETIME(), 0
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert HL7 Acknowledgement Message.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspInsertAcknowledgement';

