CREATE VIEW [dbo].[v_LegacyMonitor]
WITH
     SCHEMABINDING
AS
SELECT
    [Id],
    '6924FE52-54CC-11D3-A454-0060943F44D1' AS [UnitOrgId],
    'UVN_1' AS [NetworkId],
    NULL AS [NodeId],
    NULL AS [BedId],
    NULL AS [BedCd],
    NULL AS [Room],
    NULL AS [Description],
    [Name] AS [Name],
    'IP_0A' AS [Type],
    'SLISH' AS [Subnet]
FROM
    [dbo].[Devices];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyMonitor';

