CREATE PROCEDURE [CEI].[uspGetLicense]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipa].[ProductCode]
        FROM
            [Intesys].[ProductAccess] AS [ipa]
        WHERE
            [ipa].[ProductCode] = 'cei';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetLicense';

