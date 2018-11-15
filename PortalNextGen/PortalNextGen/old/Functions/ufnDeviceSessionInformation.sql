-- Usage: 
-- [old].[vwDeviceSessionAssignment] to return the 
CREATE FUNCTION [old].[ufnDeviceSessionInformation]
    (
        @DeviceSessionID INT,
        @Name            NVARCHAR(25)
    )
RETURNS TABLE
WITH SCHEMABINDING
AS RETURN
    SELECT
        [LatestDeviceInfo].[Value]
    FROM
        (
            SELECT
                [did].[Value],
                ROW_NUMBER() OVER (PARTITION BY
                                       [did].[DeviceSessionID]
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
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Return the latest device information for a device session and device name.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'FUNCTION', @level1name = N'ufnDeviceSessionInformation';

