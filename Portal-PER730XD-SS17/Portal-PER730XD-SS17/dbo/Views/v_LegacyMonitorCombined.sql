CREATE VIEW [dbo].[v_LegacyMonitorCombined]
WITH
     SCHEMABINDING
AS
SELECT
    [Id] AS [monitor_id],
    [UnitOrgId] AS [unit_org_id],
    [NetworkId] AS [network_id],
    [NodeId] AS [node_id],
    [BedId] AS [bed_id],
    [BedCd] AS [bed_cd],
    [Room] AS [room],
    [Description] AS [monitor_dsc],
    [Name] AS [monitor_name],
    [Type] AS [monitor_type_cd],
    [Subnet] AS [subnet]
FROM
    [dbo].[v_LegacyMonitor]
UNION ALL
SELECT
    [monitor_id],
    [unit_org_id],
    [network_id],
    [node_id],
    [bed_id],
    [bed_cd],
    [room],
    [monitor_dsc],
    [monitor_name],
    [monitor_type_cd],
    [subnet]
FROM
    [dbo].[int_monitor];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyMonitorCombined';

