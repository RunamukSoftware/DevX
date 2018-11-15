CREATE PROCEDURE [ClinicalAccess].[uspGetPatientWaveForms]
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
            [wd].[StartDateTime],
            [wd].[EndDateTime],
            CASE
                WHEN [wd].[Compressed] = 0
                    THEN NULL
                ELSE
                    'WCTZLIB'
            END            AS [compress_method],
            [wd].[Samples] AS [WaveformData],
            [wd].[TypeID]  AS [ChannelID]
        FROM
            [old].[Waveform] AS [wd]
        WHERE
            [wd].[TypeID] IN (
                                 SELECT
                                     [Item]
                                 FROM
                                     @ChannelIDs
                             )
            AND [wd].[TopicSessionID] IN (
                                             SELECT
                                                 [vpts].[TopicSessionID]
                                             FROM
                                                 [old].[vwPatientTopicSessions] AS [vpts]
                                             WHERE
                                                 [vpts].[PatientID] = @PatientID
                                         )
            AND [wd].[StartDateTime] <= @EndDateTime
            AND [wd].[EndDateTime] > @StartDateTime
        UNION ALL
        SELECT
            --[iw].[StartDateTime],
            --[iw].[EndDateTime],
            [iw].[StartDateTime],
            [iw].[EndDateTime],
            [iw].[CompressMethod],
            [iw].[WaveformData],
            [ipc].[ChannelTypeID] AS [ChannelID]
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
            [wd].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the waveform data for the given list of channels from which to make Waveform requests.', @level0type = N'SCHEMA', @level0name = N'ClinicalAccess', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientWaveForms';

