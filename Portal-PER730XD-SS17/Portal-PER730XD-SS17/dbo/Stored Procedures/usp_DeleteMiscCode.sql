CREATE PROCEDURE [dbo].[usp_DeleteMiscCode] (@code_id INT)
AS
BEGIN
    DELETE
        [dbo].[int_misc_code]
    WHERE
        [code_id] = @code_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteMiscCode';

