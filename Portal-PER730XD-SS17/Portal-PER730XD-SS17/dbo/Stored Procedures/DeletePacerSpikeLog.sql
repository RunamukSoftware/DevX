CREATE PROCEDURE [dbo].[DeletePacerSpikeLog]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @SampleRate SMALLINT
    )
AS
BEGIN
    DELETE FROM
        [dbo].[PacerSpikeLog]
    WHERE
        [user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [sample_rate] = @SampleRate;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeletePacerSpikeLog';

