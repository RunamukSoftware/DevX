CREATE PROCEDURE [old].[uspDeletePacerSpikeLog]
    (
        @UserID     INT,
        @PatientID  INT,
        @SampleRate SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [old].[PacerSpikeLog]
        WHERE
            [UserID] = @UserID
            AND [PatientID] = @PatientID
            AND [SampleRate] = @SampleRate;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeletePacerSpikeLog';

