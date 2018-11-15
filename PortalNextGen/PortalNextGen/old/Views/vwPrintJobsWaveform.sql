CREATE VIEW [old].[vwPrintJobsWaveform]
WITH SCHEMABINDING
AS
    SELECT
        [pj].[PrintJobID]                    AS [PrintJobID],
        ISNULL([PageNumber].[Value], 1)      AS [page_number],
        [cid].[ChannelIndex]                 AS [SequenceNumber],
        CAST(NULL AS VARCHAR)                AS [WaveformType],
        [Duration].[Value]                   AS [Duration],
        CAST(NULL AS VARCHAR)                AS [ChannelType],
        NULL                                 AS [ModuleNumber],
        NULL                                 AS [ChannelNumber],
        [SweepSpeed].[Value]                 AS [SweepSpeed],
        CASE
            WHEN [cid].[ScaleMin] = [cid].[ScaleMax]
                THEN [cid].[ScaleValue]
            ELSE
                [cid].[ScaleMin]
        END                                  AS [label_min],
        CASE
            WHEN [cid].[ScaleMin] = [cid].[ScaleMax]
                THEN [cid].[ScaleValue]
            ELSE
                [cid].[ScaleMax]
        END                                  AS [label_max],
        NULL                                 AS [show_units],
        [cid].[ChannelTypeID]                  AS [annotation_channel_type],
        [cid].[Baseline]                     AS [offset],
        [cid].[Scale]                        AS [scale],
        NULL                                 AS [primary_annotation],
        NULL                                 AS [secondary_annotation],
        [wpd].[Samples]                      AS [WaveformData],
        NULL                                 AS [grid_type],
        ''                                   AS [scale_labels],
        CAST([cid].[SampleRate] AS SMALLINT) AS [SampleRate],
        NULL                                 AS [RowDateTime],
        NULL                                 AS [RowID]
    FROM
        [old].[PrintRequest]          AS [pr]
        INNER JOIN
            [old].[PrintJob]          AS [pj]
                ON [pj].[PrintJobID] = [pr].[PrintJobID]
        INNER JOIN
            [old].[TopicSession]      AS [ts]
                ON [ts].[TopicSessionID] = [pj].[TopicSessionID]
        LEFT OUTER JOIN
            [old].[ChannelInformation]   AS [cid]
                ON [pr].[PrintRequestID] = [cid].[PrintRequestID]
        LEFT OUTER JOIN
            [old].[WaveformPrint] AS [wpd]
                ON [pr].[PrintRequestID] = [wpd].[PrintRequestID]
                   AND [wpd].[ChannelIndex] = [cid].[ChannelIndex]
        LEFT OUTER JOIN
            [old].[PrintRequestData]  AS [PageNumber]
                ON [pr].[PrintRequestID] = [PageNumber].[PrintRequestID]
                   AND [PageNumber].[Name] = 'PageNumber'
        LEFT OUTER JOIN
            [old].[PrintRequestData]  AS [SweepSpeed]
                ON [pr].[PrintRequestID] = [SweepSpeed].[PrintRequestID]
                   AND [SweepSpeed].[Name] = 'SweepSpeed'
        LEFT OUTER JOIN
            [old].[PrintRequestData]  AS [Duration]
                ON [pr].[PrintRequestID] = [Duration].[PrintRequestID]
                   AND [Duration].[Name] = 'Duration';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPrintJobsWaveform';

