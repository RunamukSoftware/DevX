CREATE PROCEDURE [old].[uspGetPatientChannelList] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [ipc].[ChannelTypeID] AS [PatientChannelID],
            [ipc].[ChannelTypeID] AS [CHANNEL_TYPEID]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [ipc].[ActiveSwitch] = 1
        UNION ALL
        SELECT DISTINCT
            [TypeIds].[TypeID] AS [PatientChannelID],
            [TypeIds].[TypeID] AS [CHANNEL_TYPEID]
        FROM
            (
                SELECT
                    [wl].[TypeID]
                FROM
                    [old].[WaveformLive]     AS [wl]
                    INNER JOIN
                        [old].[TopicSession] AS [ts]
                            ON [ts].[TopicInstanceID] = [wl].[TopicInstanceID]
                    LEFT OUTER JOIN
                        (
                            SELECT
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [did2].[DeviceSessionID]
                                                   ORDER BY
                                                       [did2].[DateTimeStamp] DESC
                                                  ) AS [RowNumber],
                                [did2].[DeviceSessionID],
                                [did2].[Value]
                            FROM
                                [old].[DeviceInformation] AS [did2]
                            WHERE
                                [did2].[Name] = N'MonitoringStatus'
                        )                    AS [StandbyStatus]
                            ON [StandbyStatus].[DeviceSessionID] = [ts].[DeviceSessionID]
                               AND [StandbyStatus].[RowNumber] = 1
                WHERE
                    [ts].[TopicSessionID] IN (
                                                 SELECT
                                                     [vpts2].[TopicSessionID]
                                                 FROM
                                                     [old].[vwPatientTopicSessions] AS [vpts2]
                                                 WHERE
                                                     [vpts2].[PatientID] = @PatientID
                                             )
                    AND [ts].[EndDateTime] IS NULL
                    AND ISNULL([StandbyStatus].[Value], N'Normal') <> N'Standby'
                UNION ALL
                SELECT
                    [ts].[TopicTypeID]
                FROM
                    [old].[TopicSession]       AS [ts] -- add non-waveform types
                    INNER JOIN
                        [old].[FeedType] AS [tft]
                            ON [tft].[FeedTypeID] = [ts].[TopicTypeID]
                    LEFT OUTER JOIN
                        (
                            SELECT
                                ROW_NUMBER() OVER (PARTITION BY
                                                       [did].[DeviceSessionID]
                                                   ORDER BY
                                                       [did].[DateTimeStamp] DESC
                                                  ) AS [RowNumber],
                                [did].[DeviceSessionID],
                                [did].[Value]
                            FROM
                                [old].[DeviceInformation] AS [did]
                            WHERE
                                [did].[Name] = N'MonitoringStatus'
                        )                      AS [StandbyStatus]
                            ON [StandbyStatus].[DeviceSessionID] = [ts].[DeviceSessionID]
                               AND [StandbyStatus].[RowNumber] = 1
                WHERE
                    [ts].[TopicSessionID] IN (
                                                 SELECT
                                                     [vpts].[TopicSessionID]
                                                 FROM
                                                     [old].[vwPatientTopicSessions] AS [vpts]
                                                 WHERE
                                                     [vpts].[PatientID] = @PatientID
                                             )
                    AND [ts].[EndDateTime] IS NULL
                    AND ISNULL([StandbyStatus].[Value], N'Normal') <> N'Standby'
            ) AS [TypeIds];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the list of channels with live data for an active patient', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientChannelList';

