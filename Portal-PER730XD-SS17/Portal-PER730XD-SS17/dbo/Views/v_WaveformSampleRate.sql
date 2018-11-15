CREATE VIEW [dbo].[v_WaveformSampleRate]
WITH
     SCHEMABINDING
AS
SELECT DISTINCT
    [TypeId] AS [FeedTypeId],
    [Value] AS [SampleRate],
    [EntityName] AS [TypeName]
FROM
    [dbo].[MetaData]
WHERE
    [Name] = 'SampleRate';

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the waveform sample rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_WaveformSampleRate';

