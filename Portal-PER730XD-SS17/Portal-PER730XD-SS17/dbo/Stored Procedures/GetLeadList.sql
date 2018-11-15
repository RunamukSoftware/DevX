CREATE PROCEDURE [dbo].[GetLeadList]
    (
     @PatientId [dbo].[DUSER_ID],
     @TimeTagType INT,
     @StartTime BIGINT,
     @EndTime BIGINT
    )
AS
BEGIN
    SELECT
        [ipt].[param_ft],
        [ipt].[value1],
        [ipt].[value2]
    FROM
        [dbo].[int_param_timetag] AS [ipt]
        LEFT OUTER JOIN [dbo].[v_DiscardedOverlappingLegacyWaveformData] AS [discarded]
            ON [discarded].[patient_channel_id] = [ipt].[patient_channel_id]
               AND [ipt].[param_ft] BETWEEN [discarded].[start_ft] AND [discarded].[end_ft]
               AND [ipt].[patient_id] = [discarded].[patient_id]
    WHERE
        [ipt].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [ipt].[timetag_type] = @TimeTagType
        AND [ipt].[param_ft] >= @StartTime
        AND [ipt].[param_ft] <= @EndTime
        AND [discarded].[patient_channel_id] IS NULL
    ORDER BY
        [ipt].[param_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the list of leads for the specified patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLeadList';

