CREATE VIEW [old].[vwLegacyMonitor]
WITH SCHEMABINDING
AS
    SELECT
        [DeviceID],
        '6924FE52-54CC-11D3-A454-0060943F44D1' AS [UnitOrgID],
        'UVN_1'                                AS [NetworkID],
        NULL                                   AS [NodeID],
        NULL                                   AS [BedID],
        NULL                                   AS [BedCode],
        NULL                                   AS [Room],
        NULL                                   AS [Description],
        [Name]                                 AS [Name],
        'IP_0A'                                AS [Type],
        'SLISH'                                AS [Subnet]
    FROM
        [old].[Device];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyMonitor';

