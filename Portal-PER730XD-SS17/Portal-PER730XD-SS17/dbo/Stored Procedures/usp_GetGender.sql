CREATE PROCEDURE [dbo].[usp_GetGender]
AS
BEGIN
    SELECT
        [short_dsc]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [category_cd] = 'SEX'
        AND [verification_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetGender';

