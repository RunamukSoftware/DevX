CREATE VIEW [dbo].[v_DeviceSessionInfo]
WITH
     SCHEMABINDING
AS
SELECT
    [DeviceSessionId],
    [Name],
    [Value],
    [TimestampUTC]
FROM
    (SELECT
        [DeviceSessionId],
        [TimestampUTC],
        [Name],
        [Value],
        ROW_NUMBER() OVER (PARTITION BY [DeviceSessionId], [Name] ORDER BY [TimestampUTC] DESC) AS [RowNumber]
     FROM
        [dbo].[DeviceInfoData]
    ) AS [LatestDeviceInfo]
WHERE
    [LatestDeviceInfo].[RowNumber] = 1;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DeviceSessionInfo';

