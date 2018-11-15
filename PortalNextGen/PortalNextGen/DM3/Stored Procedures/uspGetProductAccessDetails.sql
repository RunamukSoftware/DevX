CREATE PROCEDURE [DM3].[uspGetProductAccessDetails] (@Product NVARCHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipa].[ProductCode],
            [ipa].[OrganizationID],
            [ipa].[LicenseNumber]
        FROM
            [Intesys].[ProductAccess] AS [ipa]
        WHERE
            [ipa].[ProductCode] = @Product;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetProductAccessDetails';

