CREATE PROCEDURE [old].[uspGetFeatureListForProducts]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ip].[ProductCode],
            [if].[FeatureCode],
            [if].[Description]
        FROM
            [Intesys].[ProductMap]  AS [ipm]
            INNER JOIN
                [Intesys].[Product] AS [ip]
                    ON [ipm].[ProductID] = [ip].[ProductID]
            INNER JOIN
                [Intesys].[Feature] AS [if]
                    ON [ipm].[FeatureID] = [if].[FeatureID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetFeatureListForProducts';

