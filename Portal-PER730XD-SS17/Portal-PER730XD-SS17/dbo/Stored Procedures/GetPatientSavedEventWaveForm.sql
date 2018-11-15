CREATE PROCEDURE [dbo].[GetPatientSavedEventWaveForm]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [SEWF].[channel_id] AS [CHANNEL_ID],
        [SEWF].[waveform_category] AS [TYPE],
        [SEWF].[scale] AS [SCALE_VALUE],
        [SEWF].[scale_min],
        [SEWF].[scale_max],
        [SEWF].[scale_type],
        [SEWF].[sample_rate],
        [SEWF].[sample_count],
        [SEWF].[num_Ypoints],
        [SEWF].[baseline],
        [SEWF].[Ypoints_per_unit],
        [SEWF].[visible],
        [CT].[label],
        [SEWF].[waveform_data],
        [SEWF].[num_timelogs],
        [SEWF].[timelog_data],
        [SEWF].[waveform_color],
        [SEWF].[scale_unit_type]
    FROM
        [dbo].[int_savedevent_waveform] AS [SEWF]
        INNER JOIN [dbo].[int_channel_type] AS [CT] ON [SEWF].[waveform_category] = [CT].[channel_code]
    WHERE
        ([SEWF].[patient_id] = @patient_id
        AND [SEWF].[event_id] = @event_id
        AND [SEWF].[visible] = 1
        )
    ORDER BY
        [SEWF].[wave_index];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientSavedEventWaveForm';

