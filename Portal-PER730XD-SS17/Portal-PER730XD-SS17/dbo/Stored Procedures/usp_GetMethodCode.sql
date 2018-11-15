CREATE PROCEDURE [dbo].[usp_GetMethodCode]
AS
BEGIN
    SELECT DISTINCT
        [method_cd]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [method_cd] IS NOT NULL
    ORDER BY
        [method_cd];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetMethodCode';

