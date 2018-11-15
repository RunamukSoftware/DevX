CREATE VIEW [old].[vwPrintJobs]
WITH SCHEMABINDING
AS
    SELECT
            [pj].[PrintJobID]                                                 AS [PrintJobID],
            ISNULL([PageNumber].[Value], 1)                                   AS [PageNumber],
            [ds].[DeviceSessionID]                                            AS [PatientID],
            NULL                                                              AS [OriginalPatientID],
            [pr].[Timestamp]                                                  AS [JobNetDateTime],
            CONCAT([Description].[Value], ' ', [PrintDateTime].[Value]) + CASE
                                                                              WHEN [DataNode].[Value] IS NULL
                                                                                  THEN ''
                                                                              ELSE
                                                                                  ' (' + [DataNode].[Value] + ')'
                                                                          END AS [Description],
            [DataNode].[Value]                                                AS [DataNode],
            [SweepSpeed].[Value]                                              AS [SweepSpeed],
            [Duration].[Value]                                                AS [Duration],
            [NumChannels].[Value]                                             AS [NumberOfChannels],
            'jt' + ISNULL([RequestTypeEnum].[Name], 'Invalid')                AS [JobType],
            [MonitorName].[Value]                                             AS [Bed],
            [PrintDateTime].[Value]                                           AS [RecordingTime],
			[vps].[FirstName],
			[vps].[LastName],
            CASE [RequestTypeEnum].[Name]
                WHEN 'Undefined'
                    THEN ''
                WHEN 'Manual'
                    THEN ISNULL([MonitorName].[Value], '') + ' ' + [PrintDateTime].[Value] + ' ' + ISNULL([A0].[Annotation], '')
                WHEN 'Continuous'
                    THEN ''
                WHEN 'Alarm'
                    THEN ISNULL([MonitorName].[Value], '') + ' ' + ISNULL([A0].[Annotation], '')
                WHEN 'AutoAlarm'
                    THEN ISNULL([MonitorName].[Value], '') + ' ' + ISNULL([A0].[Annotation], '')
                WHEN 'ST'
                    THEN ''
                WHEN 'Arrhythmia'
                    THEN [A0].[Annotation]
                WHEN 'Bitmap'
                    THEN ''
                WHEN 'PreSelected'
                    THEN ''
                WHEN 'TwelveLead'
                    THEN ''
                WHEN 'AllLeads'
                    THEN ''
                ELSE
                    ''
            END                                                               AS [annotation1],
            CASE [RequestTypeEnum].[Name]
                WHEN 'Undefined'
                    THEN ''
                WHEN 'Manual'
                    THEN [A1].[Annotation]
                WHEN 'Continuous'
                    THEN ''
                WHEN 'Alarm'
                    THEN [A1].[Annotation]
                WHEN 'AutoAlarm'
                    THEN [A1].[Annotation]
                WHEN 'ST'
                    THEN ''
                WHEN 'Arrhythmia'
                    THEN [A1].[Annotation]
                WHEN 'Bitmap'
                    THEN ''
                WHEN 'PreSelected'
                    THEN ''
                WHEN 'TwelveLead'
                    THEN ''
                WHEN 'AllLeads'
                    THEN ''
                ELSE
                    ''
            END                                                               AS [annotation2],
            CASE [RequestTypeEnum].[Name]
                WHEN 'Undefined'
                    THEN ''
                WHEN 'Manual'
                    THEN [A2].[Annotation]
                WHEN 'Continuous'
                    THEN ''
                WHEN 'Alarm'
                    THEN [A2].[Annotation]
                WHEN 'AutoAlarm'
                    THEN [A2].[Annotation]
                WHEN 'ST'
                    THEN ''
                WHEN 'Arrhythmia'
                    THEN ''
                WHEN 'Bitmap'
                    THEN ''
                WHEN 'PreSelected'
                    THEN ''
                WHEN 'TwelveLead'
                    THEN ''
                WHEN 'AllLeads'
                    THEN ''
                ELSE
                    ''
            END                                                               AS [annotation3],
            CASE [RequestTypeEnum].[Name]
                WHEN 'Undefined'
                    THEN ''
                WHEN 'Manual'
                    THEN [A3].[Annotation]
                WHEN 'Continuous'
                    THEN ''
                WHEN 'Alarm'
                    THEN [A3].[Annotation]
                WHEN 'AutoAlarm'
                    THEN [A3].[Annotation]
                WHEN 'ST'
                    THEN ''
                WHEN 'Arrhythmia'
                    THEN ''
                WHEN 'Bitmap'
                    THEN ''
                WHEN 'PreSelected'
                    THEN ''
                WHEN 'TwelveLead'
                    THEN ''
                WHEN 'AllLeads'
                    THEN ''
                ELSE
                    ''
            END                                                               AS [annotation4],
            NULL                                                              AS [PrintBitmap],
            NULL                                                              AS [TwelveLeadData],
            NULL                                                              AS [EndOfJobSwitch],
            NULL                                                              AS [printSwitch],
            NULL                                                              AS [PrinterName],
            NULL                                                              AS [LastPrintedDateTime],
            NULL                                                              AS [StatusCode],
            NULL                                                              AS [StatusMessage],
            NULL                                                              AS [StartRecord],
            NULL                                                              AS [RowDateTime],
            NULL                                                              AS [RowID]
    FROM
            [old].[PrintRequest]            AS [pr]
        INNER JOIN
            [old].[PrintJob]                AS [pj]
                ON [pj].[PrintJobID] = [pr].[PrintJobID]
        INNER JOIN
            [old].[TopicSession]            AS [ts]
                ON [ts].[TopicSessionID] = [pj].[TopicSessionID]
        INNER JOIN
            [old].[DeviceSession]           AS [ds]
                ON [ds].[DeviceSessionID] = [ts].[DeviceSessionID]
        INNER JOIN
            [old].[vwPatientSessions]       AS [vps]
                ON [vps].[PatientID] = [ds].[DeviceSessionID]
        INNER JOIN
            [old].[Enum]                    AS [RequestTypeEnum]
                ON [RequestTypeEnum].[GroupID] = [pr].[RequestTypeEnumID]
                   AND [RequestTypeEnum].[Value] = [pr].[RequestTypeEnumValue]
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [PageNumber]
                ON [pr].[PrintRequestID] = [PageNumber].[PrintRequestID]
                   AND [PageNumber].[Name] = 'PageNumber'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [Duration]
                ON [pr].[PrintRequestID] = [Duration].[PrintRequestID]
                   AND [Duration].[Name] = 'Duration'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [NumChannels]
                ON [pr].[PrintRequestID] = [NumChannels].[PrintRequestID]
                   AND [NumChannels].[Name] = 'NumChannels'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [SweepSpeed]
                ON [pr].[PrintRequestID] = [SweepSpeed].[PrintRequestID]
                   AND [SweepSpeed].[Name] = 'SweepSpeed'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [PrintDateTime]
                ON [pr].[PrintRequestID] = [PrintDateTime].[PrintRequestID]
                   AND [PrintDateTime].[Name] = 'PrintDateTime'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [DataNode]
                ON [pr].[PrintRequestID] = [DataNode].[PrintRequestID]
                   AND [DataNode].[Name] = 'DataNode'
        LEFT OUTER JOIN
            [old].[PrintRequestData]        AS [MonitorName]
                ON [pr].[PrintRequestID] = [MonitorName].[PrintRequestID]
                   AND [MonitorName].[Name] = 'MonitorName'
        LEFT OUTER JOIN
            [old].[WaveformAnnotation]      AS [A0]
                ON [pr].[PrintRequestID] = [A0].[PrintRequestID]
                   AND [A0].[ChannelIndex] = 0
        LEFT OUTER JOIN
            [old].[WaveformAnnotation]      AS [A1]
                ON [pr].[PrintRequestID] = [A1].[PrintRequestID]
                   AND [A1].[ChannelIndex] = 1
        LEFT OUTER JOIN
            [old].[WaveformAnnotation]      AS [A2]
                ON [pr].[PrintRequestID] = [A2].[PrintRequestID]
                   AND [A2].[ChannelIndex] = 2
        LEFT OUTER JOIN
            [old].[WaveformAnnotation]      AS [A3]
                ON [pr].[PrintRequestID] = [A3].[PrintRequestID]
                   AND [A3].[ChannelIndex] = 3
        LEFT OUTER JOIN
            [old].[PrintRequestDescription] AS [Description]
                ON [Description].[RequestTypeEnumID] = [pr].[RequestTypeEnumID]
                   AND [Description].[RequestTypeEnumValue] = [pr].[RequestTypeEnumValue];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPrintJobs';

