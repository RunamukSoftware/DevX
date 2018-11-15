CREATE PROCEDURE [dbo].[RetrievePacerSpikeLog]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @SampleRate SMALLINT
    )
AS
BEGIN
    SELECT
        [psl].[user_id],
        [psl].[patient_id],
        [psl].[sample_rate],
        [psl].[start_ft],
        [psl].[num_spikes],
        [psl].[spike_data]
    FROM
        [dbo].[PacerSpikeLog] AS [psl]
    WHERE
        [psl].[user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [psl].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [psl].[sample_rate] = @SampleRate;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'RetrievePacerSpikeLog';

