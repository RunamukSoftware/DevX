CREATE PROCEDURE [dbo].[p_ml_Is_Id_On_Monitor]
    (
     @PatId AS VARCHAR(20),
     @CurrentMonitor AS VARCHAR(10) = ''
    )
AS
BEGIN
    IF @CurrentMonitor IS NULL
        SET @CurrentMonitor = '';

    SELECT
        [int_patient_monitor].[active_sw],
        [int_monitor].[monitor_name],
        [int_monitor].[standby]
    FROM
        [dbo].[int_mrn_map]
        LEFT OUTER JOIN [dbo].[int_patient_monitor] ON ([int_mrn_map].[patient_id] = [dbo].[int_patient_monitor].[patient_id]
                                                       AND [active_sw] = 1
                                                       )
        LEFT OUTER JOIN [dbo].[int_monitor] ON ([dbo].[int_patient_monitor].[monitor_id] = [dbo].[int_monitor].[monitor_id])
    WHERE
        [mrn_xid] = @PatId
        AND [int_monitor].[monitor_name] <> @CurrentMonitor
        AND [active_sw] = 1
        AND [merge_cd] = 'C'
        AND [standby] IS NULL
    UNION
    SELECT TOP (1)
        CAST(1 AS TINYINT) AS [active_sw],
        N'ET' AS [monitor_name],
        CASE [MonitoringStatus].[Value] WHEN N'Standby' THEN 1 ELSE NULL END AS [standby]
    FROM
        [dbo].[int_mrn_map]
        INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[PatientId] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
        LEFT OUTER JOIN
        (
            SELECT [DeviceSessionId],
                   [Name],
                   [Value],
                   ROW_NUMBER() OVER (PARTITION BY [DeviceSessionId], [Name] ORDER BY [TimestampUTC] DESC) AS [RowNumber]
            FROM
                [dbo].[DeviceInfoData]
            WHERE
                [Name] = N'MonitoringStatus'
        ) AS [MonitoringStatus] ON [MonitoringStatus].[DeviceSessionId]=[TopicSessions].[DeviceSessionId] AND [RowNumber]=1
    WHERE
        [int_mrn_map].[mrn_xid] = @PatId
		AND [int_mrn_map].[merge_cd] = 'C'
        AND [TopicSessions].[EndTimeUTC] IS NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_ml_Is_Id_On_Monitor';

