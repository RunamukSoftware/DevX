CREATE VIEW [old].[vwDeviceSessionOrganization]
WITH SCHEMABINDING
AS
    SELECT
        [vdsa].[DeviceSessionID],
        [Units].[OrganizationID] AS [OrganizationID]
    FROM
        [old].[vwDeviceSessionAssignment] AS [vdsa]
        LEFT OUTER JOIN
            [Intesys].[Organization]      AS [Facilities]
                ON [Facilities].[OrganizationName] = [vdsa].[FacilityName]
        LEFT OUTER JOIN
            [Intesys].[Organization]      AS [Units]
                ON [Units].[OrganizationName] = [vdsa].[UnitName]
                   AND [Units].[ParentOrganizationID] = [Facilities].[OrganizationID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDeviceSessionOrganization';

