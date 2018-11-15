CREATE PROCEDURE [old].[uspGetSysgenDetails] (@ProductCode VARCHAR(25))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [is].[ProductCode],
            [is].[FeatureCode],
            [is].[Setting]
        FROM
            [Intesys].[SystemGeneration] AS [is]
        WHERE
            [is].[ProductCode] = @ProductCode
        ORDER BY
            [is].[FeatureCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSysgenDetails';

