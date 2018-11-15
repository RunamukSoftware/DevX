CREATE PROCEDURE [dbo].[usp_SaveWaveformLiveDataSet]
    (
     @waveformData [dbo].[WaveformDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[WaveformLiveData]
            ([Id],
             [SampleCount],
             [TypeName],
             [TypeId],
             [Samples],
             [TopicInstanceId],
             [StartTimeUTC],
             [EndTimeUTC])
    SELECT
        [wf].[Id],
        [wf].[SampleCount],
        [wf].[TypeName],
        [wf].[TypeId],
        [wf].[Samples],
        [ts].[TopicInstanceId],
        [wf].[StartTimeUTC],
        [wf].[EndTimeUTC]
    FROM
        @waveformData AS [wf]
        INNER JOIN [dbo].[TopicSessions] AS [ts]
            ON [ts].[Id] = [wf].[TopicSessionId];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the patient topic session waveform live data from the caller via a table variable.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveWaveformLiveDataSet';

