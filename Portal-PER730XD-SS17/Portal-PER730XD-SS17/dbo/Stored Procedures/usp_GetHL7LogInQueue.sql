CREATE PROCEDURE [dbo].[usp_GetHL7LogInQueue] (@msg_no NVARCHAR(40))
AS
BEGIN
    SELECT
        [HL7Message] AS [Message]
    FROM
        [dbo].[HL7InboundMessage]
    WHERE
        [MessageControlId] = @msg_no;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetHL7LogInQueue';

