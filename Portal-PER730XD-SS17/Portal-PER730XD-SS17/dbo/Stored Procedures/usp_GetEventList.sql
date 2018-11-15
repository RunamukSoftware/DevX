CREATE PROCEDURE [dbo].[usp_GetEventList]
AS
BEGIN
    SELECT
        [code],
        [short_dsc]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [category_cd] = 'SLOG';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetEventList';

