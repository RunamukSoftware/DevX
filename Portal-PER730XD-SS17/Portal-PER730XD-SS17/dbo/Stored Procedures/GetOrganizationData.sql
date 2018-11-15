CREATE PROCEDURE [dbo].[GetOrganizationData]
AS
BEGIN
    SELECT
        [ORG].[organization_id],
        [ORG].[category_cd],
        [ORG].[parent_organization_id],
        [ORG].[organization_cd],
        [ORG].[organization_nm]
    FROM
        [dbo].[int_organization] AS [ORG]
    ORDER BY
        [category_cd] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the organization structure.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetOrganizationData';

