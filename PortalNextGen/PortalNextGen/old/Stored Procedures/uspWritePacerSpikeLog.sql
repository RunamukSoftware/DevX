CREATE PROCEDURE [old].[uspWritePacerSpikeLog]
    (
        @UserID         INT,
        @PatientID      INT,
        @SampleRate     SMALLINT,
        @StartDateTime  DATETIME2(7),
        @NumberOfSpikes INT,
        @SpikeData      VARBINARY(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[PacerSpikeLog]
            (
                [UserID],
                [PatientID],
                [SampleRate],
                [StartDateTime],
                [NumberOfSpikes],
                [SpikeData]
            )
        VALUES
            (
                @UserID, @PatientID, @SampleRate, @StartDateTime, @NumberOfSpikes, @SpikeData
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWritePacerSpikeLog';

