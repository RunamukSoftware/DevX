CREATE PROCEDURE [dbo].[p_gts_Channels_Info]
AS
BEGIN
    SET DEADLOCK_PRIORITY LOW;

    DECLARE
        @ActiveChannels AS INT,
        @ActiveWaveformChannels AS INT;

    SELECT
        @ActiveChannels = COUNT(*)
    FROM
        [dbo].[int_patient_channel]
        LEFT OUTER JOIN [dbo].[int_monitor] ON [int_patient_channel].[monitor_id] = [int_monitor].[monitor_id]
    WHERE
        [int_patient_channel].[active_sw] = 1
        AND [int_monitor].[monitor_id] IS NOT NULL;

    SELECT
        @ActiveWaveformChannels = COUNT(*)
    FROM
        [dbo].[int_patient_channel]
        LEFT OUTER JOIN [dbo].[int_monitor] ON [int_patient_channel].[monitor_id] = [int_monitor].[monitor_id]
        INNER JOIN [dbo].[int_channel_type] ON [int_patient_channel].[channel_type_id] = [dbo].[int_channel_type].[channel_type_id]
    WHERE
        ([int_patient_channel].[active_sw] = 1)
        AND [int_monitor].[monitor_id] IS NOT NULL
        AND [int_channel_type].[type_cd] = 'WAVEFORM';

    SELECT
        @ActiveChannels AS [ACTIVE_CHANNELS],
        @ActiveWaveformChannels AS [ACTIVE_WAVEFORM_CHANNELS];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_gts_Channels_Info';

