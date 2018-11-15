CREATE PROCEDURE [dbo].[GetLegacyPatientChannelTimes]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        MIN([iw].[start_ft]) AS [MIN_START_FT],
        MAX([iw].[end_ft]) AS [MAX_END_FT],
        [ict].[channel_code] AS [CHANNEL_CODE],
        NULL AS [LABEL],
        [ict].[priority],
        [ict].[channel_type_id] AS [CHANNEL_TYPE_ID],
        [ict].[freq] AS [SAMPLE_RATE]
    FROM
        [dbo].[int_waveform] AS [iw]
        INNER JOIN [dbo].[int_patient_channel] AS [ipc]
            ON [iw].[patient_channel_id] = [ipc].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] AS [ict]
            ON [ipc].[channel_type_id] = [ict].[channel_type_id]
    WHERE
        [iw].[patient_id] = @patient_id
    GROUP BY
        [ict].[channel_code],
        [ict].[label],
        [ict].[priority],
        [ict].[channel_type_id],
        [ict].[freq]
    ORDER BY
        [ict].[priority];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the legacy patient channel times.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientChannelTimes';

