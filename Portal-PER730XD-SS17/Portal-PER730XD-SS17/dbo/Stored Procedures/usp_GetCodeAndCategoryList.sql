CREATE PROCEDURE [dbo].[usp_GetCodeAndCategoryList]
AS
BEGIN
    SELECT
        [cat_code]
    FROM
        [dbo].[int_code_category]
    ORDER BY
        [cat_code];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetCodeAndCategoryList';

