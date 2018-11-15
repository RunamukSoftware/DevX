CREATE PROCEDURE [old].[uspGetOrganizationDataAsXml]
AS
    BEGIN
        SET NOCOUNT ON;

        WITH [tree]
        AS (   SELECT
                   [org].[OrganizationID],
                   [org].[ParentOrganizationID] AS [ParentID],
                   [org].[OrganizationName],
                   [org].[OrganizationCode]     AS [Description],
                   'ORG'                        AS [Type],
                   1                            AS [OrderBy]
               FROM
                   [Intesys].[Organization] AS [org]
               WHERE
                   [org].[ParentOrganizationID] IS NULL
               UNION
               SELECT
                   [facil].[OrganizationID],
                   [facil].[ParentOrganizationID] AS [ParentID],
                   [facil].[OrganizationName],
                   [facil].[OrganizationCode]     AS [Description],
                   'FACILITY'                     AS [Type],
                   2                              AS [OrderBy]
               FROM
                   [Intesys].[Organization]     AS [org1]
                   INNER JOIN
                       [Intesys].[Organization] AS [facil]
                           ON [org1].[OrganizationID] = [facil].[ParentOrganizationID]
                              AND [facil].[CategoryCode] = 'F' --F:facility
               UNION
               SELECT
                   [facil2].[OrganizationID],
                   [facil2].[ParentOrganizationID] AS [ParentID],
                   [facil2].[OrganizationName],
                   [facil2].[OrganizationCode]     AS [Description],
                   'UNIT'                          AS [Type],
                   3                               AS [OrderBy]
               FROM
                   [Intesys].[Organization]     AS [org1]
                   INNER JOIN
                       [Intesys].[Organization] AS [facil2]
                           ON [org1].[OrganizationID] = [facil2].[ParentOrganizationID]
                              AND [facil2].[CategoryCode] = 'D'
                              AND [org1].[CategoryCode] = 'F' -- F:facility; D-Department
        )
        SELECT
            [tree].[OrganizationID],
            [tree].[ParentID],
            [tree].[OrganizationName],
            [tree].[Description],
            [tree].[Type],
            [tree].[OrderBy]
        FROM
            [tree]
        ORDER BY
            [tree].[OrderBy],
            [tree].[Type]
        FOR XML RAW('orgitem'), ROOT;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the organizational structure as XML.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetOrganizationDataAsXml';

