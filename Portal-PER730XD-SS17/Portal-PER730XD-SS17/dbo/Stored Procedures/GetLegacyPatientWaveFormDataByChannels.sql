CREATE PROCEDURE [dbo].[GetLegacyPatientWaveFormDataByChannels]
    (
     @ChannelTypes [dbo].[StringList] READONLY,
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [pc].[channel_type_id] AS [PATIENT_CHANNEL_ID],
        [pc].[patient_monitor_id],
        [WAVFRM].[start_dt] AS [START_DT],
        [WAVFRM].[end_dt] AS [END_DT],
        [WAVFRM].[start_ft] AS [start_ft],
        [WAVFRM].[end_ft] AS [end_ft],
        [WAVFRM].[compress_method] AS [COMPRESS_METHOD],
        [WAVFRM].[waveform_data] AS [WAVEFORM_DATA],
        NULL AS [TOPIC_INSTANCE_ID]
    FROM
        [dbo].[int_patient_channel] AS [pc]
        LEFT OUTER JOIN [dbo].[int_waveform_live] AS [WAVFRM] ON [WAVFRM].[patient_channel_id] = [pc].[patient_channel_id]
    WHERE
        [pc].[patient_id] = @PatientId
        AND [pc].[channel_type_id] IN (SELECT
                                        [Item]
                                       FROM
                                        @ChannelTypes)
        AND [pc].[active_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientWaveFormDataByChannels';

