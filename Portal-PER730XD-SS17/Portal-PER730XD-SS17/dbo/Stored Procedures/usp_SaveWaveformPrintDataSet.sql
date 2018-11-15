CREATE PROCEDURE [dbo].[usp_SaveWaveformPrintDataSet]
    (
     @WaveformPrintDataSet [dbo].[WaveformPrintDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[WaveformPrintData]
    SELECT
        [Id],
        [PrintRequestId],
        [ChannelIndex],
        [NumSamples],
        [Samples]
    FROM
        @WaveformPrintDataSet;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveWaveformPrintDataSet';

