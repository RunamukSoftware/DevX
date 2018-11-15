
CREATE VIEW [old].[vwxLatestDeviceInformation]
WITH SCHEMABINDING, VIEW_METADATA
AS
    SELECT
        [LatestDeviceInfo].[DeviceSessionID],
        [LatestDeviceInfo].[Name],
        [LatestDeviceInfo].[Value],
        [LatestDeviceInfo].[DateTimeStamp]
    FROM
        (
            SELECT
                [did].[DeviceSessionID],
                [did].[Name],
                [did].[Value],
                [did].[DateTimeStamp],
                ROW_NUMBER() OVER (PARTITION BY
                                       [did].[DeviceSessionID],
                                       [did].[Name]
                                   ORDER BY
                                       [did].[DateTimeStamp] DESC
                                  ) AS [RowNumber]
            FROM
                [old].[DeviceInformation] AS [did]
        --WHERE [did].[DeviceSessionID] = @DeviceSessionID
        --      AND [did].[Name] = @Name
        ) AS [LatestDeviceInfo]
    WHERE
        [LatestDeviceInfo].[RowNumber] = 1;
-- WITH CHECK OPTION