CREATE PROCEDURE [old].[uspSaveWaveformAnnotationDataSet]
    (@WaveformAnnotationDataSet [old].[utpWaveformAnnotation] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[WaveformAnnotation]
            (
                [PrintRequestID],
                [ChannelIndex],
                [Annotation]
            )
                    SELECT
                        [PrintRequestID],
                        [ChannelIndex],
                        [Annotation]
                    FROM
                        @WaveformAnnotationDataSet;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveWaveformAnnotationDataSet';

