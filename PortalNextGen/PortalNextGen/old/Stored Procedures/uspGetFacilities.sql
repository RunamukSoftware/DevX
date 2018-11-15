CREATE PROCEDURE [old].[uspGetFacilities]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[OrganizationID]   AS [FacilityID],
            [io].[OrganizationCode] AS [FACILITY_CODE],
            [io].[OrganizationName] AS [FACILITY_NAME]
        FROM
            [Intesys].[Organization] AS [io]
        WHERE
            [io].[CategoryCode] = 'F'
        ORDER BY
            [io].[OrganizationCode];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetFacilities';

