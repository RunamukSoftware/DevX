CREATE VIEW [dbo].[v_DeviceSessionOrganization]
WITH
     SCHEMABINDING
AS
SELECT
    [DeviceSessionId],
    [OrganizationId] = [Units].[organization_id]
FROM
    [dbo].[v_DeviceSessionAssignment]
    LEFT OUTER JOIN [dbo].[int_organization] AS [Facilities] ON [Facilities].[organization_nm] = [v_DeviceSessionAssignment].[FacilityName]
    LEFT OUTER JOIN [dbo].[int_organization] AS [Units] ON [Units].[organization_nm] = [v_DeviceSessionAssignment].[UnitName]
                                                           AND [Units].[parent_organization_id] = [Facilities].[organization_id];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DeviceSessionOrganization';

