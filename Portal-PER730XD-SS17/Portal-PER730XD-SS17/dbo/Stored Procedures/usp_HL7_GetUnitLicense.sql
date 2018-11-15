CREATE PROCEDURE [dbo].[usp_HL7_GetUnitLicense]
    (
     @productcd VARCHAR(25),
     @categoryCd CHAR(1),
     @organizationId UNIQUEIDENTIFIER,
     @OrgCode NVARCHAR(20) OUT
    )
AS
BEGIN
    SET @OrgCode = (SELECT
                        [ORG].[organization_cd]
                    FROM
                        [dbo].[int_organization] AS [ORG]
                        INNER JOIN [dbo].[int_product_access] AS [PROACC] ON [PROACC].[organization_id] = [ORG].[organization_id]
                    WHERE
                        [PROACC].[product_cd] = @productcd
                        AND [ORG].[category_cd] = @categoryCd
                        AND [ORG].[organization_id] = @organizationId
                   );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Unit license by Unit Code Or Unit ID.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetUnitLicense';

