CREATE PROCEDURE [Purger].[uspDeleteWaveform]
    (
        @ChunkSize          INT,
        @PurgeDateTime      DATETIME2(7),
        @WaveformDataPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        SET @WaveformDataPurged = 0;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [wf]
                FROM
                    [Intesys].[Waveform] AS [wf]
                WHERE
                    [wf].[EndDateTime] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [at]
                FROM
                    [old].[AnalysisTime] AS [at]
                WHERE
                    [at].[InsertDateTime] < @PurgeDateTime;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipc]
                FROM
                    [Intesys].[PatientChannel]     AS [ipc]
                    INNER JOIN
                        [Intesys].[PatientMonitor] AS [ipm]
                            ON [ipc].[PatientMonitorID] = [ipm].[PatientMonitorID]
                    INNER JOIN
                        [Intesys].[Encounter]      AS [ie]
                            ON [ipm].[EncounterID] = [ie].[EncounterID]
                WHERE
                    [ie].[DischargeDateTime] < @PurgeDateTime
                    AND [ipc].[ActiveSwitch] IS NULL
                    AND NOT EXISTS
                    (
                        SELECT
                            1
                        FROM
                            [Intesys].[Waveform] AS [iw]
                        WHERE
                            [iw].[PatientChannelID] = [ipc].[PatientChannelID]
                    );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @WaveformDataPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge old waveform, analysis and patient channel data', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteWaveform';

