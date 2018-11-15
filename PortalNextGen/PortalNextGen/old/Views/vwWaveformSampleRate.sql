CREATE VIEW [old].[vwWaveformSampleRate]
WITH SCHEMABINDING
AS
    SELECT DISTINCT
        [m].[TypeID]     AS [FeedTypeID],
        [m].[Value]      AS [SampleRate],
        [m].[EntityName] AS [TypeName]
    FROM
        [old].[Metadata] AS [m]
    WHERE
        [m].[Name] = 'SampleRate';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the waveform sample rate.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwWaveformSampleRate';

