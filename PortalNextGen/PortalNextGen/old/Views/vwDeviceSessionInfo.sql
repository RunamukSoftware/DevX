CREATE VIEW [old].[vwDeviceSessionInfo]
WITH SCHEMABINDING
AS
    SELECT
        [LatestDeviceInfo].[DeviceSessionID],
        [LatestDeviceInfo].[Name],
        [LatestDeviceInfo].[Value],
        [LatestDeviceInfo].[DateTimeStamp]
    FROM
        (
            SELECT
                [DeviceSessionID],
                [DateTimeStamp],
                [Name],
                [Value],
                ROW_NUMBER() OVER (PARTITION BY
                                       [DeviceSessionID],
                                       [Name]
                                   ORDER BY
                                       [DateTimeStamp] DESC
                                  ) AS [RowNumber]
            FROM
                [old].[DeviceInformation]
        ) AS [LatestDeviceInfo]
    WHERE
        [LatestDeviceInfo].[RowNumber] = 1;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDeviceSessionInfo';

