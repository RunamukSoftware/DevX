CREATE PROCEDURE [dbo].[GetOrganizationDataAsXml]
AS
BEGIN
    WITH    [tree]
              AS (SELECT
                    [org].[organization_id] AS [id],
                    [org].[parent_organization_id] AS [parentid],
                    [org].[organization_nm] AS [name],
                    [org].[organization_cd] AS [description],
                    'ORG' AS [type],
                    1 AS [orderby]
                  FROM
                    [dbo].[int_organization] AS [org]
                  WHERE
                    [org].[parent_organization_id] IS NULL
                  UNION
                  SELECT
                    [facil].[organization_id] AS [id],
                    [facil].[parent_organization_id] AS [parentid],
                    [facil].[organization_nm] AS [name],
                    [facil].[organization_cd] AS [description],
                    'FACILITY' AS [type],
                    2 AS [orderby]
                  FROM
                    [dbo].[int_organization] AS [org1]
                    INNER JOIN [dbo].[int_organization] AS [facil] ON [org1].[organization_id] = [facil].[parent_organization_id]
                                                                      AND [facil].[category_cd] = 'F' --F:facility
                  UNION
                  SELECT
                    [facil2].[organization_id] AS [id],
                    [facil2].[parent_organization_id] AS [parentid],
                    [facil2].[organization_nm] AS [name],
                    [facil2].[organization_cd] AS [description],
                    'UNIT' AS [type],
                    3 AS [orderby]
                  FROM
                    [dbo].[int_organization] AS [org1]
                    INNER JOIN [dbo].[int_organization] AS [facil2] ON [org1].[organization_id] = [facil2].[parent_organization_id]
                                                                       AND [facil2].[category_cd] = 'D'
                                                                       AND [org1].[category_cd] = 'F' -- F:facility; D-Department
                 )
        SELECT
            [tree].[id],
            [tree].[parentid],
            [tree].[name],
            [tree].[description],
            [tree].[type],
            [tree].[orderby]
        FROM
            [tree]
        ORDER BY
            [tree].[orderby],
            [tree].[type]
    FOR
            XML RAW('orgitem'),
                ROOT;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the organizational structure as XML.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetOrganizationDataAsXml';

