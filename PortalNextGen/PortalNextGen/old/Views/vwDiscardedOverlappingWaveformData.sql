CREATE VIEW [old].[vwDiscardedOverlappingWaveformData]
WITH SCHEMABINDING
AS
    SELECT
        [vlw].[WaveformID],
        [vlw].[TopicSessionID],
        [vlw].[StartDateTime],
        [vlw].[EndDateTime]
    FROM
        [old].[vwLegacyWaveform]     AS [vlw]
        INNER JOIN
            [old].[vwLegacyWaveform] AS [vlw2]
                ON [vlw].[PatientID] = [vlw2].[PatientID]
                   AND [vlw].[TypeID] = [vlw2].[TypeID]
                   AND [vlw].[TopicSessionID] <> [vlw2].[TopicSessionID]
                   AND [vlw].[SessionBegin] <= [vlw2].[SessionBegin]
                   AND [vlw2].[StartDateTime] < [vlw].[EndDateTime]
                   AND [vlw].[StartDateTime] < [vlw2].[EndDateTime];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwDiscardedOverlappingWaveformData';

