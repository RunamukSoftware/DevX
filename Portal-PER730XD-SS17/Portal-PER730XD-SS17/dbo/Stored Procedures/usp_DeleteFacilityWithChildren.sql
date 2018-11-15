CREATE PROCEDURE [dbo].[usp_DeleteFacilityWithChildren]
AS
BEGIN
    DELETE FROM
        [dbo].[int_organization]
    WHERE
        [parent_organization_id] IS NOT NULL
        AND [parent_organization_id] NOT IN (SELECT
                                                [organization_id]
                                             FROM
                                                [dbo].[int_organization]);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteFacilityWithChildren';

