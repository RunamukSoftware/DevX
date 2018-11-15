-- Usage: 
-- [dbo].[v_DeviceSessionAssignment] to return the 
CREATE FUNCTION [dbo].[ufnDeviceSessionInfo]
    (
     @DeviceSessionId UNIQUEIDENTIFIER,
     @Name NVARCHAR(25)
    )
RETURNS TABLE
    WITH SCHEMABINDING
    AS
RETURN
    SELECT
        [LatestDeviceInfo].[Value]
    FROM
        (SELECT
            [did].[Value],
            ROW_NUMBER() OVER (PARTITION BY [did].[DeviceSessionId] ORDER BY [did].[TimestampUTC] DESC) AS [RowNumber]
         FROM
            [dbo].[DeviceInfoData] AS [did]
         WHERE
            [did].[DeviceSessionId] = @DeviceSessionId
            AND [did].[Name] = @Name
        ) AS [LatestDeviceInfo]
    WHERE
        [LatestDeviceInfo].[RowNumber] = 1;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the latest device information for a device session and device name.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'ufnDeviceSessionInfo';

