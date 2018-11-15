CREATE PROCEDURE [DM3].[uspAddPatientMonitor]
    (
        @PatientMonitorID INT          = NULL,
        @PatientID        INT          = NULL,
        @MonitorID        INT          = NULL,
        @ConnectDateTime  DATETIME2(7) = NULL,
        @EncounterID      INT          = NULL
    )
AS
    BEGIN
SET NOCOUNT ON;

        INSERT INTO [Intesys].[PatientMonitor]
            (
                [PatientMonitorID],
                [PatientID],
                [MonitorID],
                [MonitorInterval],
                [PollingType],
                [MonitorConnectDateTime],
                [EncounterID],
                [ActiveSwitch]
            )
        VALUES
            (
                @PatientMonitorID, @PatientID, @MonitorID, 1, 'P', @ConnectDateTime, @EncounterID, 1
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddPatientMonitor';

