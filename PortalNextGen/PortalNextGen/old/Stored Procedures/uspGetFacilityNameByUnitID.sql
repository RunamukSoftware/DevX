CREATE PROCEDURE [old].[uspGetFacilityNameByUnitID] (@UnitID AS INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io2].[OrganizationName]
        FROM
            [Intesys].[Organization] AS [io2]
        WHERE
            [io2].[OrganizationID] =
            (
                SELECT
                    [io].[ParentOrganizationID]
                FROM
                    [Intesys].[Organization] AS [io]
                WHERE
                    [io].[OrganizationID] = @UnitID
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetFacilityNameByUnitID';

