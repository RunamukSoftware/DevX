CREATE PROCEDURE [dbo].[GetPatientChannelList]
    (
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT DISTINCT
        [channel_type_id] AS [PATIENT_CHANNEL_ID],
        [channel_type_id] AS [CHANNEL_TYPE_ID]
    FROM
        [dbo].[int_patient_channel]
    WHERE
        [patient_id] = @PatientId
        AND [active_sw] = 1
    UNION ALL
    SELECT DISTINCT
        [TypeId] AS [PATIENT_CHANNEL_ID],
        [TypeId] AS [CHANNEL_TYPE_ID]
    FROM
        (SELECT
            [TypeId]
         FROM
            [dbo].[WaveformLiveData] WITH (SNAPSHOT)
            INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [WaveformLiveData].[TopicInstanceId]
            LEFT OUTER JOIN (SELECT
                ROW_NUMBER() OVER (PARTITION BY [DeviceInfoData].[DeviceSessionId] ORDER BY [TimestampUTC] DESC) AS [RowNumber],
                [DeviceSessionId],
                [Value]
            FROM
                [dbo].[DeviceInfoData]
            WHERE [Name]=N'MonitoringStatus'
            ) AS [StandbyStatus] ON [StandbyStatus].[DeviceSessionId]=[TopicSessions].[DeviceSessionId] AND [StandbyStatus].[RowNumber]=1
         WHERE
            [TopicSessions].[Id] IN (SELECT
                                        [TopicSessionId]
                                     FROM
                                        [dbo].[v_PatientTopicSessions]
                                     WHERE
                                        [PatientId] = @PatientId)
            AND [TopicSessions].[EndTimeUTC] IS NULL
            AND ISNULL([StandbyStatus].[Value], N'Normal') <> N'Standby'
         UNION ALL
         SELECT
            [TopicSessions].[TopicTypeId]
         FROM
            [dbo].[TopicSessions] -- add non-waveform types
            INNER JOIN [dbo].[TopicFeedTypes] ON [TopicFeedTypes].[FeedTypeId] = [TopicSessions].[TopicTypeId]
            LEFT OUTER JOIN (SELECT
                ROW_NUMBER() OVER (PARTITION BY [DeviceInfoData].[DeviceSessionId] ORDER BY [TimestampUTC] DESC) AS [RowNumber],
                [DeviceSessionId],
                [Value]
            FROM
                [dbo].[DeviceInfoData]
            WHERE [Name]=N'MonitoringStatus'
            ) AS [StandbyStatus] ON [StandbyStatus].[DeviceSessionId]=[TopicSessions].[DeviceSessionId] AND [StandbyStatus].[RowNumber]=1
         WHERE
            [TopicSessions].[Id] IN (SELECT
                                        [TopicSessionId]
                                     FROM
                                        [dbo].[v_PatientTopicSessions]
                                     WHERE
                                        [PatientId] = @PatientId)
            AND [TopicSessions].[EndTimeUTC] IS NULL
            AND ISNULL([StandbyStatus].[Value], N'Normal') <> N'Standby'
        ) AS [TypeIds];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the list of channels with live data for an active patient', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientChannelList';

