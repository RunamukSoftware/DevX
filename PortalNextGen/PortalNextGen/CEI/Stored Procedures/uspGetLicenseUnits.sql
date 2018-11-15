CREATE PROCEDURE [CEI].[uspGetLicenseUnits]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[OrganizationCode]
        FROM
            [Intesys].[Organization]      AS [io]
            INNER JOIN
                [Intesys].[ProductAccess] AS [ipa]
                    ON [io].[OrganizationID] = [ipa].[OrganizationID]
        WHERE
            [ipa].[ProductCode] = 'cei';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetLicenseUnits';

