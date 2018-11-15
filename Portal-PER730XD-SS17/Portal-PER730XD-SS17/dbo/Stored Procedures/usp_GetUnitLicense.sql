CREATE PROCEDURE [dbo].[usp_GetUnitLicense]
    (
     @productcd VARCHAR(25),
     @categoryCd CHAR(1),
     @organizationId UNIQUEIDENTIFIER,
     @organizationCd NVARCHAR(40) = NULL
    )
AS
BEGIN
    IF (@organizationCd IS NOT NULL)
    BEGIN
        SELECT
            [ORG].[organization_cd] AS [ORGCD]
        FROM
            [dbo].[int_organization] AS [ORG]
            INNER JOIN [dbo].[int_product_access] AS [PROACC] ON [PROACC].[organization_id] = [ORG].[organization_id]
        WHERE
            [PROACC].[product_cd] = @productcd
            AND [ORG].[category_cd] = @categoryCd
            AND ([ORG].[organization_id] = @organizationId
            AND [ORG].[organization_cd] = @organizationCd
            );
    END;
    ELSE
    BEGIN
        SELECT
            [ORG].[organization_cd] AS [ORGCD]
        FROM
            [dbo].[int_organization] AS [ORG]
            INNER JOIN [dbo].[int_product_access] AS [PROACC] ON [PROACC].[organization_id] = [ORG].[organization_id]
        WHERE
            [PROACC].[product_cd] = @productcd
            AND [ORG].[category_cd] = @categoryCd
            AND [ORG].[organization_id] = @organizationId;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Unit license by Unit Code Or Unit Id.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetUnitLicense';

