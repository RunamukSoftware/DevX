CREATE VIEW [old].[vwLegacyMonitorCombined]
WITH SCHEMABINDING
AS
    SELECT
        [vlm].[DeviceID]    AS [MonitorID],
        [vlm].[UnitOrgID]   AS [UnitOrganizationID],
        [vlm].[NetworkID],
        [vlm].[NodeID],
        [vlm].[BedID],
        [vlm].[BedCode],
        [vlm].[Room],
        [vlm].[Description] AS [MonitorDescription],
        [vlm].[Name]        AS [MonitorName],
        [vlm].[Type]        AS [MonitorTypeCode],
        [vlm].[Subnet]      AS [Subnet]
    FROM
        [old].[vwLegacyMonitor] AS [vlm]
    UNION ALL
    SELECT
        [im].[MonitorID],
        [im].[UnitOrganizationID],
        [im].[NetworkID],
        [im].[NodeID],
        [im].[BedID],
        [im].[BedCode],
        [im].[Room],
        [im].[MonitorDescription],
        [im].[MonitorName],
        [im].[MonitorTypeCode],
        [im].[Subnet]
    FROM
        [Intesys].[Monitor] AS [im];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyMonitorCombined';

