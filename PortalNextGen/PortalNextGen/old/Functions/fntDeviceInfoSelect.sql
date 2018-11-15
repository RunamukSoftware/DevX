CREATE FUNCTION [old].[fntDeviceInfoSelect]
    (
        @DeviceSessionID INT,
        @Name AS         NVARCHAR(25)
    )
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
    SELECT
        --[LatestDeviceInfo].[DeviceSessionID],
        --[LatestDeviceInfo].[Name],
        [LatestDeviceInfo].[Value],
        [LatestDeviceInfo].[DateTimeStamp]
    FROM
        (
            SELECT
                --[did].[DeviceSessionID],
                --[did].[Name],
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
            WHERE
                [did].[DeviceSessionID] = @DeviceSessionID
                AND [did].[Name] = @Name
        ) AS [LatestDeviceInfo]
    WHERE
        [LatestDeviceInfo].[RowNumber] = 1;