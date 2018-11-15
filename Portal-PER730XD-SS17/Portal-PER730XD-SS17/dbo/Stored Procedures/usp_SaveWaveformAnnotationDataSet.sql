CREATE PROCEDURE [dbo].[usp_SaveWaveformAnnotationDataSet]
    (
     @WaveformAnnotationDataSet [dbo].[WaveformAnnotationDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[WaveformAnnotationData]
    SELECT
        [Id],
        [PrintRequestId],
        [ChannelIndex],
        [Annotation]
    FROM
        @WaveformAnnotationDataSet;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveWaveformAnnotationDataSet';

