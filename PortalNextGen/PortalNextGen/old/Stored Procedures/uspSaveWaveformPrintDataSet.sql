CREATE PROCEDURE [old].[uspSaveWaveformPrintDataSet] (@WaveformPrintDataSet [old].[utpWaveformPrint] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[WaveformPrint]
            (
                [PrintRequestID],
                [ChannelIndex],
                [NumSamples],
                [Samples]
            )
                    SELECT
                        [PrintRequestID],
                        [ChannelIndex],
                        [NumSamples],
                        [Samples]
                    FROM
                        @WaveformPrintDataSet;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveWaveformPrintDataSet';

