CREATE PROCEDURE [DM3].[uspUpdateActiveSwitchInPatientMonitor] (@MonitorID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [ActiveSwitch] = NULL
        WHERE
            [MonitorID] = @MonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdateActiveSwitchInPatientMonitor';

