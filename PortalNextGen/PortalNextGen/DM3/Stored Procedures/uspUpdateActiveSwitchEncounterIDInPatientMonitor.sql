CREATE PROCEDURE [DM3].[uspUpdateActiveSwitchEncounterIDInPatientMonitor]
    (
        @MonitorID       INT,
        @PatientID       INT,
        @ConnectDateTime DATETIME2(7) = NULL,
        @EncounterID     INT          = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [ActiveSwitch] = 1,
            [EncounterID] = @EncounterID
        WHERE
            [MonitorID] = @MonitorID
            AND [PatientID] = @PatientID
            AND [MonitorConnectDateTime] = @ConnectDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdateActiveSwitchEncounterIDInPatientMonitor';

