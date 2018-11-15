CREATE PROCEDURE [dbo].[WritePacerSpikeLog]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @SampleRate SMALLINT,
     @StartFt BIGINT,
     @NumSpikes INT,
     @SpikeData IMAGE
    )
AS
BEGIN
    INSERT  INTO [dbo].[PacerSpikeLog]
            ([user_id],
             [patient_id],
             [sample_rate],
             [start_ft],
             [num_spikes],
             [spike_data]
            )
    VALUES
            (CAST(@UserID AS UNIQUEIDENTIFIER),
             CAST(@PatientId AS UNIQUEIDENTIFIER),
             @SampleRate,
             @StartFt,
             @NumSpikes,
             @SpikeData
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WritePacerSpikeLog';

