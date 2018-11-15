CREATE PROCEDURE [DM3].[uspDeleteVitals] (@CollectDateTime DATETIME2(7))
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ivl]
        FROM
            [Intesys].[VitalLive] AS [ivl]
        WHERE
            [ivl].[CollectionDateTime] < @CollectDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspDeleteVitals';

