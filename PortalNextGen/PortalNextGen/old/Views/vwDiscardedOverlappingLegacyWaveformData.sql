CREATE VIEW [old].[vwDiscardedOverlappingLegacyWaveformData]
WITH SCHEMABINDING
AS
    SELECT
            [ipc1].[PatientID],
            [vlw].[PatientChannelID],
            --[vlw].[StartDateTime],
            --[vlw].[EndDateTime]
            [vlw].[StartDateTime],
            [vlw].[EndDateTime]
    FROM
            [Intesys].[PatientChannel] AS [ipc1]
        INNER JOIN
            [Intesys].[PatientMonitor] AS [ipm1]
                ON [ipc1].[PatientMonitorID] = [ipm1].[PatientMonitorID]
        INNER JOIN
            [Intesys].[Encounter]      AS [E1]
                ON [ipm1].[EncounterID] = [E1].[EncounterID]
        INNER JOIN
            [Intesys].[PatientChannel] AS [ipc2]
                ON [ipc1].[PatientID] = [ipc2].[PatientID]
                   AND [ipc1].[PatientChannelID] <> [ipc2].[PatientChannelID]
                   AND [ipc1].[ChannelTypeID] = [ipc2].[ChannelTypeID]
                   AND
                       (
                           [ipc1].[MonitorID] <> [ipc2].[MonitorID]
                           OR [ipc2].[ModuleNumber] < [ipc1].[ModuleNumber]
                       )
        INNER JOIN
            [Intesys].[PatientMonitor] AS [ipm2]
                ON [ipc2].[PatientMonitorID] = [ipm2].[PatientMonitorID]
        INNER JOIN
            [Intesys].[Encounter]      AS [E2]
                ON [ipm2].[EncounterID] = [E2].[EncounterID]
                   AND [E1].[BeginDateTime] <= [E2].[BeginDateTime]
        INNER JOIN
            [Intesys].[Waveform]       AS [vlw]
                ON [vlw].[PatientChannelID] = [ipc1].[PatientChannelID]
        INNER JOIN
            [Intesys].[Waveform]       AS [vlw2]
                ON [vlw2].[PatientChannelID] = [ipc2].[PatientChannelID]
                   AND [vlw2].[StartDateTime] < [vlw].[EndDateTime]
                   AND [vlw].[StartDateTime] < [vlw2].[EndDateTime];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Consolidate the patient channel information for the data between the start and end dates.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDiscardedOverlappingLegacyWaveformData';

