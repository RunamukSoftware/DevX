CREATE PROCEDURE [dbo].[GetUnitAutoCollectInterval]
    (
     @unit_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [auto_collect_interval] AS [INTERVAL]
    FROM
        [dbo].[int_organization]
    WHERE
        [category_cd] = 'D'
        AND [organization_id] = @unit_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetUnitAutoCollectInterval';

