CREATE PROCEDURE [old].[uspGetUnitsByFacility]
    (
        @FacilityID INT,
        @LoginName  NVARCHAR(64)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[OrganizationName] AS [UNIT_NAME],
            [io].[OrganizationID]   AS [UnitID]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[ParentOrganizationID] = @FacilityID
            AND [io].[CategoryCode] = 'D'
            AND [io].[OrganizationID] NOT IN (
                                                 SELECT
                                                     [cro].[OrganizationID]
                                                 FROM
                                                     [CDR].[RestrictedOrganization] AS [cro]
                                                 WHERE
                                                     [cro].[RoleID] =
                                                     (
                                                         SELECT
                                                             [iu].[RoleID]
                                                         FROM
                                                             [User].[User] AS [iu]
                                                         WHERE
                                                             [iu].[LoginName] = @LoginName
                                                     )
                                             )
        ORDER BY
            [io].[OrganizationName];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitsByFacility';

