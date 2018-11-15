CREATE PROCEDURE [Purger].[uspDeleteEnhancedTelemetryPrintJob]
    (
        @ChunkSize       INT,
        @PurgeDate       DATETIME2(7),
        @PrintJobsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                -- Delete alarm data
                DELETE TOP (@ChunkSize)
                [ipjet]
                FROM
                    [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [ipjet] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [ipjet].[RowLastUpdatedOn] <= @PurgeDate
                    AND [ipjet].[AlarmEndDateTime] IS NOT NULL;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        -- Delete vitals data
        SELECT DISTINCT
            [Vitals].[PrintJobEnhancedTelemetryVitalID]
        INTO
            [#VitalsToDelete]
        FROM
            [Intesys].[PrintJobEnhancedTelemetryVital]     AS [Vitals]
            LEFT OUTER JOIN
                [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [Alarm]
                    ON [Vitals].[TopicSessionID] = [Alarm].[TopicSessionID]
                       AND [Vitals].[ResultDateTime] >= [Alarm].[AlarmStartDateTime]
                       AND [Vitals].[ResultDateTime] <= [Alarm].[AlarmEndDateTime]
        WHERE
            [Alarm].[TopicSessionID] IS NULL; -- We only want the Ids where there is no corresponding Alarm

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipjet]
                FROM
                    [Intesys].[PrintJobEnhancedTelemetryVital] AS [ipjet] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [PrintJobEnhancedTelemetryVitalID] IN (
                                SELECT
                                    [PrintJobEnhancedTelemetryVitalID]
                                FROM
                                    [#VitalsToDelete]
                            );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        -- Delete waveform data
        SELECT
            [Waveform].[PrintJobEnhancedTelemetryWaveformID]
        INTO
            [#WaveformsToDelete]
        FROM
            [Intesys].[PrintJobEnhancedTelemetryWaveform]  AS [Waveform]
            LEFT OUTER JOIN
                [Intesys].[PrintJobEnhancedTelemetryAlarm] AS [Alarm]
                    ON [Waveform].[DeviceSessionID] = [Alarm].[DeviceSessionID]
                       AND [Waveform].[StartDateTime] < [Alarm].[AlarmEndDateTime]
                       AND [Waveform].[EndDateTime] > [Alarm].[AlarmStartDateTime]
        WHERE
            [Alarm].[TopicSessionID] IS NULL; -- We only want the Ids where there is no corresponding Alarm

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipjet]
                FROM
                    [Intesys].[PrintJobEnhancedTelemetryWaveform] AS [ipjet] WITH (ROWLOCK) -- Do not allow lock escalations.
                WHERE
                    [PrintJobEnhancedTelemetryWaveformID] IN (
                                SELECT
                                    [PrintJobEnhancedTelemetryWaveformID]
                                FROM
                                    [#WaveformsToDelete]
                            );

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @PrintJobsPurged = @RC;

        DROP TABLE [#VitalsToDelete];

        DROP TABLE [#WaveformsToDelete];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purges old alarm report data previously saved for ET Print Jobs.  Used by the ICS_PurgeData SqlAgentJob.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteEnhancedTelemetryPrintJob';

