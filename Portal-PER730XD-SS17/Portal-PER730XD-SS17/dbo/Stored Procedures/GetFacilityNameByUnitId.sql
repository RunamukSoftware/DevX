CREATE PROCEDURE [dbo].[GetFacilityNameByUnitId]
    (
     @unit_id AS UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [organization_nm]
    FROM
        [dbo].[int_organization]
    WHERE
        [organization_id] = (SELECT
                                [io].[parent_organization_id]
                             FROM
                                [dbo].[int_organization] AS [io]
                             WHERE
                                [io].[organization_id] = @unit_id
                            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetFacilityNameByUnitId';

