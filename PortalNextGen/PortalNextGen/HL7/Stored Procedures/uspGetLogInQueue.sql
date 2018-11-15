CREATE PROCEDURE [HL7].[uspGetLogInQueue] (@MessageNumber NVARCHAR(40))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [him].[HL7Message] AS [Message]
        FROM
            [HL7].[InboundMessage] AS [him]
        WHERE
            [him].[MessageControlID] = @MessageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetLogInQueue';

