CREATE PROCEDURE [dbo].[GetPatientWaveFormTimeUpdate]
    (
     @patient_id UNIQUEIDENTIFIER,
     @after_ft BIGINT
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
        AND [iw].[start_ft] > @after_ft
    ORDER BY
        [iw].[start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform starting time and file time after a specified file time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientWaveFormTimeUpdate';

