CREATE PROCEDURE [old].[uspGetUnit]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io1].[OrganizationCode] + ' - ' + [io].[OrganizationCode],
            [io].[OrganizationName],
            [io].[OrganizationID],
            [io].[ParentOrganizationID],
            [io].[OrganizationCode]
        FROM
            [Intesys].[Organization]     AS [io]
            INNER JOIN
                [Intesys].[Organization] AS [io1]
                    ON [io].[ParentOrganizationID] = [io1].[OrganizationID]
        WHERE
            [io].[CategoryCode] = 'D'
        ORDER BY
            [io1].[OrganizationCode] + ' - ' + [io].[OrganizationCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve a list of unit names for use in ICS Admin.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetUnit';

