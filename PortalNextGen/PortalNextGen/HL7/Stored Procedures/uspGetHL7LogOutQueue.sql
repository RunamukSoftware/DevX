CREATE PROCEDURE [HL7].[uspGetHL7LogOutQueue] (@MessageNumber CHAR(20))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            ISNULL([hoq].[ShortText], [hoq].[LongText]) AS [Message]
        FROM
            [HL7].[OutputQueue] AS [hoq]
        WHERE
            [hoq].[MessageNumber] = @MessageNumber;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetHL7LogOutQueue';

