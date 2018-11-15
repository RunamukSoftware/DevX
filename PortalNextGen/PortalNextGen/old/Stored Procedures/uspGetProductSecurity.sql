CREATE PROCEDURE [old].[uspGetProductSecurity]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [p].[ProductCode],
            [p].[OrganizationID],
            [p].[LicenseNumber]
        FROM
            [Intesys].[ProductAccess]    AS [p]
            INNER JOIN
                [Intesys].[Organization] AS [o]
                    ON [p].[OrganizationID] = [o].[OrganizationID]
        WHERE
            [o].[CategoryCode] = 'D';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetProductSecurity';

