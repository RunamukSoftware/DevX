CREATE PROCEDURE [old].[uspGetUnitAutoCollectInterval] (@UnitID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[AutoCollectInterval] AS [INTERVAL]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[CategoryCode] = 'D'
            AND [io].[OrganizationID] = @UnitID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitAutoCollectInterval';

