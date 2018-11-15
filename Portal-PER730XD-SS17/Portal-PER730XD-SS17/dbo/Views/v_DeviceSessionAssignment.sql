CREATE VIEW [dbo].[v_DeviceSessionAssignment]
WITH
     SCHEMABINDING
AS
SELECT
    [DeviceSessions].[Id] AS [DeviceSessionId],
       /* The only case implemented here is the case of ETR, which provides in the device info, the key " Unit " with a value
        * in the form "FacilityName+UnitName".
        */
    CASE WHEN CHARINDEX('+', [InfoUnit].[Value]) > 0 THEN LEFT([InfoUnit].[Value], CHARINDEX('+', [InfoUnit].[Value]) - 1)
         ELSE NULL
    END AS [FacilityName],
    CASE WHEN CHARINDEX('+', [InfoUnit].[Value]) > 0 THEN SUBSTRING([InfoUnit].[Value], CHARINDEX('+', [InfoUnit].[Value]) + 1, LEN([InfoUnit].[Value]))
         ELSE NULL
    END AS [UnitName],
    [InfoBed].[Value] AS [BedName],
    [InfoDeviceName].[Value] AS [MonitorName],
    [InfoTransmitter].[Value] AS [Channel]
FROM
    [dbo].[DeviceSessions]
    LEFT OUTER JOIN [dbo].[v_DeviceSessionInfo] AS [InfoBed] ON [InfoBed].[DeviceSessionId] = [DeviceSessions].[Id]
                                                                AND [InfoBed].[Name] = 'Bed'
    LEFT OUTER JOIN [dbo].[v_DeviceSessionInfo] AS [InfoDeviceName] ON [InfoDeviceName].[DeviceSessionId] = [DeviceSessions].[Id]
                                                                       AND [InfoDeviceName].[Name] = 'DeviceName'
    LEFT OUTER JOIN [dbo].[v_DeviceSessionInfo] AS [InfoUnit] ON [InfoUnit].[DeviceSessionId] = [DeviceSessions].[Id]
                                                                 AND [InfoUnit].[Name] = 'Unit'
    LEFT OUTER JOIN [dbo].[v_DeviceSessionInfo] AS [InfoTransmitter] ON [InfoTransmitter].[DeviceSessionId] = [DeviceSessions].[Id]
                                                                        AND [InfoTransmitter].[Name] = 'Transmitter';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DeviceSessionAssignment';

