CREATE PROCEDURE [DM3].[uspGetPatientMonitor]
    (
        @MonitorID       INT,
        @PatientID       INT,
        @ConnectDateTime DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipm].[PatientMonitorID],
            [ipm].[PatientID],
            [ipm].[OriginalPatientID],
            [ipm].[MonitorID],
            [ipm].[MonitorInterval],
            [ipm].[PollingType],
            [ipm].[MonitorConnectDateTime],
            [ipm].[MonitorConnectNumber],
            [ipm].[DisableSwitch],
            [ipm].[LastPollingDateTime],
            [ipm].[LastResultDateTime],
            [ipm].[LastEpisodicDateTime],
            [ipm].[PollStartDateTime],
            [ipm].[PollEndDateTime],
            [ipm].[LastOutboundDateTime],
            [ipm].[MonitorStatus],
            [ipm].[MonitorError],
            [ipm].[EncounterID],
            [ipm].[LiveUntilDateTime],
            [ipm].[ActiveSwitch]
        FROM
            [Intesys].[PatientMonitor] AS [ipm]
        WHERE
            [ipm].[MonitorID] = @MonitorID
            AND [ipm].[PatientID] = @PatientID
            AND [ipm].[MonitorConnectDateTime] = @ConnectDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientMonitor';

