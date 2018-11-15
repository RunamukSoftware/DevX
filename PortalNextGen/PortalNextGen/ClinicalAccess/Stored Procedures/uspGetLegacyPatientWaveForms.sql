CREATE PROCEDURE [ClinicalAccess].[uspGetLegacyPatientWaveForms]
    (
        @PatientID     INT,
        @ChannelIDs    [old].[utpStringList] READONLY,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iw].[StartDateTime],
            [iw].[EndDateTime],
            [iw].[CompressMethod],
            [iw].[WaveformData],
            [ipc].[ChannelTypeID]
        FROM
            [Intesys].[Waveform]           AS [iw]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [iw].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[PatientMonitor] AS [ipm]
                    ON [ipc].[PatientMonitorID] = [ipm].[PatientMonitorID]
            INNER JOIN
                [Intesys].[Encounter]      AS [ie]
                    ON [ipm].[EncounterID] = [ie].[EncounterID]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [ipc].[ChannelTypeID] IN (
                                             SELECT
                                                 [Item]
                                             FROM
                                                 @ChannelIDs
                                         )
            AND @StartDateTime < [iw].[EndDateTime]
            AND @EndDateTime >= [iw].[StartDateTime]
        ORDER BY
            [iw].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Clinical Access legacy patient waveforms.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientWaveForms';

