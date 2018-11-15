CREATE FUNCTION [dbo].[fntDeviceInfoSelect]
    (
    @DeviceSessionId UNIQUEIDENTIFIER,
    @Name AS NVARCHAR(25))
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
SELECT
    [LatestDeviceInfo].[Value],
    [LatestDeviceInfo].[TimestampUTC]
FROM (   SELECT
             [did].[Value],
             [did].[TimestampUTC],
             ROW_NUMBER() OVER (PARTITION BY
                                    [did].[DeviceSessionId],
                                    [did].[Name]
                                ORDER BY [did].[TimestampUTC] DESC) AS [RowNumber]
         FROM [dbo].[DeviceInfoData] AS [did]
         WHERE [did].[DeviceSessionId] = @DeviceSessionId
               AND [did].[Name] = @Name) AS [LatestDeviceInfo]
WHERE [LatestDeviceInfo].[RowNumber] = 1;
