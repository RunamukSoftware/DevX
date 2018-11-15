CREATE PROCEDURE [dbo].[usp_GetHL7LogOutQueue] (@msg_no CHAR(20))
AS
BEGIN
    SELECT
        ISNULL([HL7_text_short], [HL7_text_long]) AS [Message]
    FROM
        [dbo].[HL7_out_queue]
    WHERE
        [msg_no] = @msg_no;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetHL7LogOutQueue';

