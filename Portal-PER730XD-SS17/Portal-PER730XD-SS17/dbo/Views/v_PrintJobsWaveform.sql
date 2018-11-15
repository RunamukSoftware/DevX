CREATE VIEW [dbo].[v_PrintJobsWaveform]
WITH
     SCHEMABINDING
AS
SELECT
    [print_job_id] = [PrintJobs].[Id],
    [page_number] = ISNULL([PageNumber].[Value], 1),
    [seq_no] = [ChannelInfoData].[ChannelIndex],
    [waveform_type] = CAST(NULL AS VARCHAR),
    [duration] = [Duration].[Value],
    [channel_type] = CAST(NULL AS VARCHAR),
    [module_num] = NULL,
    [channel_num] = NULL,
    [sweep_speed] = [SweepSpeed].[Value],
    [label_min] = CASE WHEN [ChannelInfoData].[ScaleMin] = [ChannelInfoData].[ScaleMax] THEN [ChannelInfoData].[ScaleValue]
                       ELSE [ChannelInfoData].[ScaleMin]
                  END,
    [label_max] = CASE WHEN [ChannelInfoData].[ScaleMin] = [ChannelInfoData].[ScaleMax] THEN [ChannelInfoData].[ScaleValue]
                       ELSE [ChannelInfoData].[ScaleMax]
                  END,
    [show_units] = NULL,
    [annotation_channel_type] = [ChannelInfoData].[ChannelType],
    [offset] = [ChannelInfoData].[Baseline],
    [scale] = [ChannelInfoData].[Scale],
    [primary_annotation] = NULL,
    [secondary_annotation] = NULL,
    [waveform_data] = [WaveformPrintData].[Samples],
    [grid_type] = NULL,
    [scale_labels] = '',
    [sample_rate] = CAST([ChannelInfoData].[SampleRate] AS SMALLINT),
    [row_dt] = NULL,
    [row_id] = NULL
FROM
    [dbo].[PrintRequests]
    INNER JOIN [dbo].[PrintJobs] ON [PrintJobs].[Id] = [PrintRequests].[PrintJobId]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [PrintJobs].[TopicSessionId]
    LEFT OUTER JOIN [dbo].[ChannelInfoData] ON [PrintRequests].[Id] = [ChannelInfoData].[PrintRequestId]
    LEFT OUTER JOIN [dbo].[WaveformPrintData] ON [PrintRequests].[Id] = [WaveformPrintData].[PrintRequestId]
                                                 AND [WaveformPrintData].[ChannelIndex] = [ChannelInfoData].[ChannelIndex]
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [PageNumber] ON [PrintRequests].[Id] = [PageNumber].[PrintRequestId]
                                                             AND [PageNumber].[Name] = 'PageNumber'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [SweepSpeed] ON [PrintRequests].[Id] = [SweepSpeed].[PrintRequestId]
                                                             AND [SweepSpeed].[Name] = 'SweepSpeed'
    LEFT OUTER JOIN [dbo].[PrintRequestData] AS [Duration] ON [PrintRequests].[Id] = [Duration].[PrintRequestId]
                                                           AND [Duration].[Name] = 'Duration';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PrintJobsWaveform';

