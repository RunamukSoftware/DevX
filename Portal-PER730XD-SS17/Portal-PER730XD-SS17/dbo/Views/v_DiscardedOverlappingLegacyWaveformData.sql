CREATE VIEW [dbo].[v_DiscardedOverlappingLegacyWaveformData]
WITH
     SCHEMABINDING
AS
SELECT
    [WF1].[patient_id],
    [WF1].[patient_channel_id],
    [WF1].[start_ft],
    [WF1].[end_ft]
FROM
    [dbo].[int_patient_channel] AS [PC1]
    INNER JOIN [dbo].[int_patient_monitor] AS [PM1] ON [PC1].[patient_monitor_id] = [PM1].[patient_monitor_id]
    INNER JOIN [dbo].[int_encounter] AS [E1] ON [PM1].[encounter_id] = [E1].[encounter_id]
    INNER JOIN [dbo].[int_patient_channel] AS [PC2] ON [PC1].[patient_id] = [PC2].[patient_id]
                                                    AND [PC1].[patient_channel_id] <> [PC2].[patient_channel_id]
                                                    AND [PC1].[channel_type_id] = [PC2].[channel_type_id]
                                                    AND ([PC1].[monitor_id] <> [PC2].[monitor_id]
                                                    OR [PC2].[module_num] < [PC1].[module_num]
                                                    )
    INNER JOIN [dbo].[int_patient_monitor] AS [PM2] ON [PC2].[patient_monitor_id] = [PM2].[patient_monitor_id]
    INNER JOIN [dbo].[int_encounter] AS [E2] ON [PM2].[encounter_id] = [E2].[encounter_id]
                                             AND [E1].[begin_dt] <= [E2].[begin_dt]
    INNER JOIN [dbo].[int_waveform] AS [WF1] ON [WF1].[patient_channel_id] = [PC1].[patient_channel_id]
    INNER JOIN [dbo].[int_waveform] AS [WF2] ON [WF2].[patient_channel_id] = [PC2].[patient_channel_id]
                                             AND [WF2].[start_ft] < [WF1].[end_ft]
                                             AND [WF1].[start_ft] < [WF2].[end_ft];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Consolidate the patient channel information for the data between the start and end dates.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DiscardedOverlappingLegacyWaveformData';

