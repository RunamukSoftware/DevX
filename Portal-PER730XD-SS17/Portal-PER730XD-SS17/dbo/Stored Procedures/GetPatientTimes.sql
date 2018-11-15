CREATE PROCEDURE [dbo].[GetPatientTimes]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([iw].[start_ft]) AS [start_ft],
        MAX([iw].[end_ft]) AS [end_ft]
    FROM
        [dbo].[int_patient_channel] AS [ipc]
        INNER JOIN [dbo].[int_waveform] AS [iw]
            ON [ipc].[patient_channel_id] = [iw].[patient_channel_id]
    WHERE
        [iw].[patient_id] = @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient waveform starting and ending file times.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientTimes';

