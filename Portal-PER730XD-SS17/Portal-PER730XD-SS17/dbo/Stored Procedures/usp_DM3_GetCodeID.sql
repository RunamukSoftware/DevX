CREATE PROCEDURE [dbo].[usp_DM3_GetCodeID]
AS
BEGIN
    SELECT
        [code_id],
        [code]
    FROM
        [dbo].[int_misc_code]
    WHERE
        [organization_id] IS NULL
        AND [code] IS NOT NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_GetCodeID';

