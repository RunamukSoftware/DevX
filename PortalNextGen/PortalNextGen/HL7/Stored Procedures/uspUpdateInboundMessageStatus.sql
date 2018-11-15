CREATE PROCEDURE [HL7].[uspUpdateInboundMessageStatus]
    (
        @MessageStatus CHAR(1),
        @MessageNumber INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [HL7].[InboundMessage]
        SET
            [MessageStatus] = @MessageStatus,
            [MessageProcessedDate] = SYSUTCDATETIME()
        WHERE
            [MessageNumber] = @MessageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the Inbound Response message of Type ADT and QRY.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateInboundMessageStatus';

