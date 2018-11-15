CREATE PROCEDURE [dbo].[usp_GetCodeIDByName]
    (
     @short_dsc NVARCHAR(100)
    )
AS
BEGIN
    SELECT
        [code_id]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [short_dsc] = @short_dsc;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetCodeIDByName';

