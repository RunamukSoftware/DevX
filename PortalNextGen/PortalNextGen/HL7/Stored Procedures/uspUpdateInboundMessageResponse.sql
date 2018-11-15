CREATE PROCEDURE [HL7].[uspUpdateInboundMessageResponse]
    (
        @MessageNumber   INT,
        @MessageResponse NVARCHAR(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [HL7].[InboundMessage]
        SET
            [HL7MessageResponse] = @MessageResponse
        WHERE
            [MessageNumber] = @MessageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update status of inbound messages of Type ADT and QRY.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateInboundMessageResponse';

