CREATE PROCEDURE [dbo].[usp_CheckNewIDUnique] (@value INT)
AS
BEGIN
    SELECT
        COUNT(*) AS [TotalCount]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [code_id] = @value;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CheckNewIDUnique';

