CREATE PROCEDURE [dbo].[GetLegacyPatientWaveFormTimeHistory]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [iw].[start_ft],
        [iw].[start_dt]
    FROM
        [dbo].[int_patient_channel] AS [ipc]
        INNER JOIN [dbo].[int_waveform] AS [iw]
            ON [ipc].[patient_channel_id] = [iw].[patient_channel_id]
    WHERE
        [iw].[patient_id] = @patient_id
    ORDER BY
        [iw].[start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientWaveFormTimeHistory';

