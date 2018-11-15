CREATE PROCEDURE [old].[uspSaveWaveformDataSet] (@WaveformData [old].[utpWaveform] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Waveform]
            (
                [SampleCount],
                [TypeName],
                [TypeID],
                [Samples],
                [Compressed],
                [TopicSessionID],
                [StartDateTime],
                [EndDateTime]
            )
                    SELECT
                        [wd].[SampleCount],
                        [wd].[TypeName],
                        [wd].[TypeID],
                        [wd].[Samples],
                        [wd].[Compressed],
                        [wd].[TopicSessionID],
                        [wd].[StartDateTime],
                        [wd].[EndDateTime]
                    FROM
                        @WaveformData AS [wd];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveWaveformDataSet';

