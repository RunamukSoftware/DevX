CREATE PROCEDURE [old].[uspSaveWaveformLiveDataSet] (@waveformData [old].[utpWaveform] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[WaveformLive]
            (
                [SampleCount],
                [TypeName],
                [TypeID],
                [Samples],
                [TopicInstanceID],
                [StartDateTime],
                [EndDateTime]
            )
                    SELECT
                        [wf].[SampleCount],
                        [wf].[TypeName],
                        [wf].[TypeID],
                        [wf].[Samples],
                        [ts].[TopicInstanceID],
                        [wf].[StartDateTime],
                        [wf].[EndDateTime]
                    FROM
                        @waveformData            AS [wf]
                        INNER JOIN
                            [old].[TopicSession] AS [ts]
                                ON [ts].[TopicSessionID] = [wf].[TopicSessionID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save the patient topic session waveform live data from the caller via a table variable.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveWaveformLiveDataSet';

