CREATE PROCEDURE [dbo].[GetFacilities]
AS
BEGIN
    SELECT
        [ORG].[organization_id] AS [FACILITY_ID],
        [ORG].[organization_cd] AS [FACILITY_CODE],
        [ORG].[organization_nm] AS [FACILITY_NAME]
    FROM
        [dbo].[int_organization] AS [ORG]
    WHERE
        [ORG].[category_cd] = 'F'
    ORDER BY
        [ORG].[organization_cd];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetFacilities';

