CREATE PROCEDURE [old].[uspGetPatientWaveformDataByChannels]
    (
        @ChannelTypes [old].[utpStringList] READONLY,
        @PatientID    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [Waveforms].[PatientChannelID],
            [Waveforms].[PatientMonitorID],
            [Waveforms].[StartDateTime],
            [Waveforms].[EndDateTime],
            [Waveforms].[COMPRESS_METHOD],
            [Waveforms].[WaveformData],
            [Waveforms].[TOPIC_INSTANCEID]
        FROM
            (
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY
                                           [iwl].[TypeID]
                                       ORDER BY
                                           [iwl].[StartDateTime] DESC
                                      )     AS [RowNumber],
                    [iwl].[TypeID]          AS [PatientChannelID],
                    [ts].[DeviceSessionID]  AS [PatientMonitorID],
                    [iwl].[StartDateTime],
                    [iwl].[EndDateTime],
                    NULL                    AS [COMPRESS_METHOD],
                    [iwl].[Samples]         AS [WaveformData],
                    [iwl].[TopicInstanceID] AS [TOPIC_INSTANCEID]
                FROM
                    [old].[WaveformLive]     AS [iwl]
                    INNER JOIN
                        [old].[TopicSession] AS [ts]
                            ON [ts].[TopicInstanceID] = [iwl].[TopicInstanceID]
                WHERE
                    [ts].[TopicSessionID] IN (
                                                 SELECT
                                                     [vpts].[TopicSessionID]
                                                 FROM
                                                     [old].[vwPatientTopicSessions] AS [vpts]
                                                 WHERE
                                                     [vpts].[PatientID] = @PatientID
                                             )
                    AND [iwl].[TypeID] IN (
                                              SELECT
                                                  [Item]
                                              FROM
                                                  @ChannelTypes
                                          )
                    AND [ts].[EndDateTime] IS NULL
            ) AS [Waveforms]
        WHERE
            [Waveforms].[RowNumber] = 1
        UNION ALL
        SELECT
            [ipc].[ChannelTypeID]     AS [PatientChannelID],
            [ipc].[PatientMonitorID],
            [WAVFRM].[StartDateTime]  AS [StartDateTime],
            [WAVFRM].[EndDateTime]    AS [EndDateTime],
            [WAVFRM].[CompressMethod] AS [COMPRESS_METHOD],
            [WAVFRM].[WaveformData]   AS [WaveformData],
            NULL                      AS [TOPIC_INSTANCEID]
        FROM
            [Intesys].[PatientChannel]   AS [ipc]
            LEFT OUTER JOIN
                [Intesys].[WaveformLive] AS [WAVFRM]
                    ON [WAVFRM].[PatientChannelID] = [ipc].[PatientChannelID]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [ipc].[ChannelTypeID] IN (
                                             SELECT
                                                 [Item]
                                             FROM
                                                 @ChannelTypes
                                         )
            AND [ipc].[ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientWaveformDataByChannels';

