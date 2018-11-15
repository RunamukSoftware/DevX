CREATE PROCEDURE [old].[uspDeleteMonitor] (@MonitorID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [Intesys].[Monitor]
        WHERE
            [MonitorID] = @MonitorID;

        DELETE FROM
        [old].[Device]
        WHERE
            [DeviceID] = @MonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delete UV or XTR monitor from the appropriate table.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteMonitor';

