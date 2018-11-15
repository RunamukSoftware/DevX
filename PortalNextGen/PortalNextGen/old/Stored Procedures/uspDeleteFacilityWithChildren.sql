CREATE PROCEDURE [old].[uspDeleteFacilityWithChildren]
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [io]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[ParentOrganizationID] IS NOT NULL
            AND [io].[ParentOrganizationID] NOT IN (
                                                       SELECT
                                                           [io2].[OrganizationID]
                                                       FROM
                                                           [Intesys].[Organization] AS [io2]
                                                   );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteFacilityWithChildren';

