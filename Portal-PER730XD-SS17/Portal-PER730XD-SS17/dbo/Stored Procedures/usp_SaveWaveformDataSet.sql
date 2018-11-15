CREATE PROCEDURE [dbo].[usp_SaveWaveformDataSet]
    (
     @waveformData [dbo].[WaveformDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[WaveformData]
            ([Id],
             [SampleCount],
             [TypeName],
             [TypeId],
             [Samples],
             [Compressed],
             [TopicSessionId],
             [StartTimeUTC],
             [EndTimeUTC]
            )
    SELECT
        [Id],
        [SampleCount],
        [TypeName],
        [TypeId],
        [Samples],
        [Compressed],
        [TopicSessionId],
        [StartTimeUTC],
        [EndTimeUTC]
    FROM
        @waveformData;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveWaveformDataSet';

