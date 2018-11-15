CREATE PROCEDURE [old].[uspRetrievePacerSpikeLog]
    (
        @UserID     INT,
        @PatientID  INT,
        @SampleRate SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [psl].[UserID],
            [psl].[PatientID],
            [psl].[SampleRate],
            [psl].[StartDateTime],
            [psl].[NumberOfSpikes],
            [psl].[SpikeData]
        FROM
            [old].[PacerSpikeLog] AS [psl]
        WHERE
            [psl].[UserID] = @UserID
            AND [psl].[PatientID] = @PatientID
            AND [psl].[SampleRate] = @SampleRate;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrievePacerSpikeLog';

