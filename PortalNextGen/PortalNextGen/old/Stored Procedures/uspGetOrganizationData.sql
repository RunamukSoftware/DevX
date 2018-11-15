CREATE PROCEDURE [old].[uspGetOrganizationData]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ORG].[OrganizationID],
            [ORG].[CategoryCode],
            [ORG].[ParentOrganizationID],
            [ORG].[OrganizationCode],
            [ORG].[OrganizationName]
        FROM
            [Intesys].[Organization] AS [ORG]
        ORDER BY
            [ORG].[CategoryCode] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the organization structure.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetOrganizationData';

