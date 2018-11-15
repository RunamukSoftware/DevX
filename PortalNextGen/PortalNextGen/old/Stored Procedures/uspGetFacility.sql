CREATE PROCEDURE [old].[uspGetFacility]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[OrganizationCode],
            [io].[OrganizationName],
            [io].[OrganizationID],
            [io].[ParentOrganizationID]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[CategoryCode] = 'F';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetFacility';

