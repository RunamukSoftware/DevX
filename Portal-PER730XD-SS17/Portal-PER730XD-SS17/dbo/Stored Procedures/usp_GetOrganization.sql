CREATE PROCEDURE [dbo].[usp_GetOrganization]
AS
BEGIN
    SELECT
        [organization_cd],
        [organization_nm],
        [organization_id],
        [parent_organization_id]
    FROM
        [dbo].[int_organization]
    WHERE
        [category_cd] = 'O';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetOrganization';

