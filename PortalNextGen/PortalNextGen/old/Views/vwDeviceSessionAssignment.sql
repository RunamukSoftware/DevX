CREATE VIEW [old].[vwDeviceSessionAssignment]
WITH SCHEMABINDING
AS
    SELECT
        [ds].[DeviceSessionID],
        -- The only case implemented here is the case of ETR, which provides in the device info, 
        -- the key " Unit " with a value in the form "FacilityName+UnitName".
        CASE
            WHEN CHARINDEX(N'+', [InfoUnit].[Value]) > 0
                THEN LEFT([InfoUnit].[Value], CHARINDEX(N'+', [InfoUnit].[Value]) - 1)
            ELSE
                NULL
        END                       AS [FacilityName],
        CASE
            WHEN CHARINDEX(N'+', [InfoUnit].[Value]) > 0
                THEN SUBSTRING([InfoUnit].[Value], CHARINDEX(N'+', [InfoUnit].[Value]) + 1, LEN([InfoUnit].[Value]))
            ELSE
                NULL
        END                       AS [UnitName],
        [InfoBed].[Value]         AS [BedName],
        [InfoDeviceName].[Value]  AS [MonitorName],
        [InfoTransmitter].[Value] AS [Channel]
    FROM
        [old].[DeviceSession]                                                   AS [ds]
        OUTER APPLY [old].[fntDeviceInfoSelect]([ds].[DeviceSessionID], N'Bed') AS [InfoBed]
        OUTER APPLY [old].[fntDeviceInfoSelect]([ds].[DeviceSessionID], N'DeviceName') AS [InfoDeviceName]
        OUTER APPLY [old].[fntDeviceInfoSelect]([ds].[DeviceSessionID], N'Unit') AS [InfoUnit]
        OUTER APPLY [old].[fntDeviceInfoSelect]([ds].[DeviceSessionID], N'Transmitter') AS [InfoTransmitter];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDeviceSessionAssignment';

