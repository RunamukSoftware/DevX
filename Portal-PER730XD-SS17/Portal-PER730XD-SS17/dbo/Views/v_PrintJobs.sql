
CREATE VIEW [dbo].[v_PrintJobs]
WITH
     SCHEMABINDING
AS
SELECT
    [pj].[Id] AS [print_job_id],
    ISNULL([PageNumber].[Value], 1) AS [page_number],
    [ds].[Id] AS [patient_id],
    NULL AS [orig_patient_id],
    --[dbo].[fnUtcDateTimeToLocalTime]([PrintRequests].[TimestampUTC]) AS [job_net_dt],
    [job_net_dt].[LocalDateTime] AS [job_net_dt],
    ISNULL([Description].[Value], '') + ' ' + ISNULL([PrintDateTime].[Value], '') + CASE WHEN [DataNode].[Value] IS NULL THEN ''
                                                                                         ELSE ' (' + [DataNode].[Value] + ')'
                                                                                    END AS [descr],
    [DataNode].[Value] AS [data_node],
    [SweepSpeed].[Value] AS [sweep_speed],
    [Duration].[Value] AS [duration],
    [NumChannels].[Value] AS [num_channels],
    'jt' + ISNULL([RequestTypeEnum].[Name], 'Invalid') AS [job_type],
    [MonitorName].[Value] AS [bed],
    [PrintDateTime].[Value] AS [recording_time],
    CASE [RequestTypeEnum].[Name]
      WHEN 'Undefined' THEN ''
      WHEN 'Manual' THEN ISNULL([vps].[patient_name], '') + ' ' + ISNULL([MonitorName].[Value], '') + ' ' + [PrintDateTime].[Value] + ' ' + ISNULL([A0].[Annotation], '')
      WHEN 'Continuous' THEN ''
      WHEN 'Alarm' THEN ISNULL([vps].[patient_name], '') + ' ' + ISNULL([MonitorName].[Value], '') + ' ' + ISNULL([A0].[Annotation], '')
      WHEN 'AutoAlarm' THEN ISNULL([vps].[patient_name], '') + ' ' + ISNULL([MonitorName].[Value], '') + ' ' + ISNULL([A0].[Annotation], '')
      WHEN 'ST' THEN ''
      WHEN 'Arrhythmia' THEN [A0].[Annotation]
      WHEN 'Bitmap' THEN ''
      WHEN 'PreSelected' THEN ''
      WHEN 'TwelveLead' THEN ''
      WHEN 'AllLeads' THEN ''
      ELSE ''
    END AS [annotation1],
    CASE [RequestTypeEnum].[Name]
      WHEN 'Undefined' THEN ''
      WHEN 'Manual' THEN [A1].[Annotation]
      WHEN 'Continuous' THEN ''
      WHEN 'Alarm' THEN [A1].[Annotation]
      WHEN 'AutoAlarm' THEN [A1].[Annotation]
      WHEN 'ST' THEN ''
      WHEN 'Arrhythmia' THEN [A1].[Annotation]
      WHEN 'Bitmap' THEN ''
      WHEN 'PreSelected' THEN ''
      WHEN 'TwelveLead' THEN ''
      WHEN 'AllLeads' THEN ''
      ELSE ''
    END AS [annotation2],
    CASE [RequestTypeEnum].[Name]
      WHEN 'Undefined' THEN ''
      WHEN 'Manual' THEN [A2].[Annotation]
      WHEN 'Continuous' THEN ''
      WHEN 'Alarm' THEN [A2].[Annotation]
      WHEN 'AutoAlarm' THEN [A2].[Annotation]
      WHEN 'ST' THEN ''
      WHEN 'Arrhythmia' THEN ''
      WHEN 'Bitmap' THEN ''
      WHEN 'PreSelected' THEN ''
      WHEN 'TwelveLead' THEN ''
      WHEN 'AllLeads' THEN ''
      ELSE ''
    END AS [annotation3],
    CASE [RequestTypeEnum].[Name]
      WHEN 'Undefined' THEN ''
      WHEN 'Manual' THEN [A3].[Annotation]
      WHEN 'Continuous' THEN ''
      WHEN 'Alarm' THEN [A3].[Annotation]
      WHEN 'AutoAlarm' THEN [A3].[Annotation]
      WHEN 'ST' THEN ''
      WHEN 'Arrhythmia' THEN ''
      WHEN 'Bitmap' THEN ''
      WHEN 'PreSelected' THEN ''
      WHEN 'TwelveLead' THEN ''
      WHEN 'AllLeads' THEN ''
      ELSE ''
    END AS [annotation4],
    NULL AS [print_bitmap],
    NULL AS [twelve_lead_data],
    NULL AS [end_of_job_sw],
    NULL AS [print_sw],
    NULL AS [printer_name],
    NULL AS [last_printed_dt],
    NULL AS [status_code],
    NULL AS [status_msg],
    NULL AS [start_rec],
    NULL AS [row_dt],
    NULL AS [row_id]
FROM
    [dbo].[PrintRequests]
    INNER JOIN [dbo].[PrintJobs] AS [pj] ON [pj].[Id] = [PrintRequests].[PrintJobId]
    INNER JOIN [dbo].[TopicSessions] AS [ts] ON [ts].[Id] = [pj].[TopicSessionId]
    INNER JOIN [dbo].[DeviceSessions] AS [ds] ON [ds].[Id] = [ts].[DeviceSessionId]
    INNER JOIN [dbo].[v_PatientSessions] AS [vps] ON [vps].[patient_id] = [ds].[Id]
    INNER JOIN [dbo].[Enums] AS [RequestTypeEnum] ON [RequestTypeEnum].[GroupId] = [PrintRequests].[RequestTypeEnumId]
                                                     AND [RequestTypeEnum].[Value] = [PrintRequests].[RequestTypeEnumValue]
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [PageNumber] ON [PrintRequests].[Id] = [PageNumber].[PrintRequestId]
                                                                AND [PageNumber].[Name] = 'PageNumber'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [Duration] ON [PrintRequests].[Id] = [Duration].[PrintRequestId]
                                                              AND [Duration].[Name] = 'Duration'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [NumChannels] ON [PrintRequests].[Id] = [NumChannels].[PrintRequestId]
                                                                 AND [NumChannels].[Name] = 'NumChannels'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [SweepSpeed] ON [PrintRequests].[Id] = [SweepSpeed].[PrintRequestId]
                                                                AND [SweepSpeed].[Name] = 'SweepSpeed'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [PrintDateTime] ON [PrintRequests].[Id] = [PrintDateTime].[PrintRequestId]
                                                                   AND [PrintDateTime].[Name] = 'PrintDateTime'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [DataNode] ON [PrintRequests].[Id] = [DataNode].[PrintRequestId]
                                                              AND [DataNode].[Name] = 'DataNode'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [MonitorName] ON [PrintRequests].[Id] = [MonitorName].[PrintRequestId]
                                                                 AND [MonitorName].[Name] = 'MonitorName'
    LEFT OUTER JOIN [dbo].[WaveformAnnotationData] AS [A0] ON [PrintRequests].[Id] = [A0].[PrintRequestId]
                                                              AND [A0].[ChannelIndex] = 0
    LEFT OUTER JOIN [dbo].[WaveformAnnotationData] AS [A1] ON [PrintRequests].[Id] = [A1].[PrintRequestId]
                                                              AND [A1].[ChannelIndex] = 1
    LEFT OUTER JOIN [dbo].[WaveformAnnotationData] AS [A2] ON [PrintRequests].[Id] = [A2].[PrintRequestId]
                                                              AND [A2].[ChannelIndex] = 2
    LEFT OUTER JOIN [dbo].[WaveformAnnotationData] AS [A3] ON [PrintRequests].[Id] = [A3].[PrintRequestId]
                                                              AND [A3].[ChannelIndex] = 3
    LEFT OUTER JOIN [dbo].[PrintRequestDescriptions] AS [Description] ON [Description].[RequestTypeEnumId] = [PrintRequests].[RequestTypeEnumId]
                                                                         AND [Description].[RequestTypeEnumValue] = [PrintRequests].[RequestTypeEnumValue]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([PrintRequests].[TimestampUTC]) AS [job_net_dt]

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PrintJobs';

