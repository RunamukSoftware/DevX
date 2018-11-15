CREATE PROCEDURE [old].[uspGetCodeAndCategoryList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [icc].[CategoryCode]
        FROM
            [Intesys].[CodeCategory] AS [icc]
        ORDER BY
            [icc].[CategoryCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetCodeAndCategoryList';

