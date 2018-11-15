CREATE PROCEDURE [old].[uspGetRestrictedUnitList] (@UserRoleID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [cro].[OrganizationID]
        FROM
            [CDR].[RestrictedOrganization] AS [cro]
            INNER JOIN
                [Intesys].[Organization]        AS [ORG]
                    ON [ORG].[OrganizationID] = [cro].[OrganizationID]
        WHERE
            [cro].[RoleID] = @UserRoleID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get all the restricted units of role.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetRestrictedUnitList';

