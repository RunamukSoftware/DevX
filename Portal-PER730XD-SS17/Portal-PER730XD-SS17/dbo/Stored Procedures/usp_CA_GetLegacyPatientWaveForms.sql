CREATE PROCEDURE [dbo].[usp_CA_GetLegacyPatientWaveForms]
    (
     @patient_id UNIQUEIDENTIFIER,
     @channelIds [dbo].[StringList] READONLY,
     @start_ft BIGINT,
     @end_ft BIGINT
    )
AS
BEGIN
    SELECT
        [iw].[start_ft],
        [iw].[end_ft],
        [iw].[start_dt],
        [iw].[end_dt],
        [iw].[compress_method],
        CAST([iw].[waveform_data] AS VARBINARY(MAX)) AS [waveform_data],
        [ipc].[channel_type_id] AS [channel_id]
    FROM
        [dbo].[int_waveform] AS [iw]
        INNER JOIN [dbo].[int_patient_channel] AS [ipc]
            ON [iw].[patient_channel_id] = [ipc].[patient_channel_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [ipm]
            ON [ipc].[patient_monitor_id] = [ipm].[patient_monitor_id]
        INNER JOIN [dbo].[int_encounter] AS [ie]
            ON [ipm].[encounter_id] = [ie].[encounter_id]
    WHERE
        [iw].[patient_id] = @patient_id
        AND [ipc].[channel_type_id] IN (SELECT
                                            [Item]
                                        FROM
                                            @channelIds)
        AND @start_ft < [iw].[end_ft]
        AND @end_ft >= [iw].[start_ft]
    ORDER BY
        [iw].[start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Clinical Access legacy patient waveforms.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CA_GetLegacyPatientWaveForms';

