CREATE VIEW [dbo].[v_DiscardedOverlappingWaveformData]
WITH
     SCHEMABINDING
AS
SELECT
    [WF1].[Id],
    [WF1].[TopicSessionId],
    [WF1].[FileTimeStampBeginUTC],
    [WF1].[FileTimeStampEndUTC]
FROM
    [dbo].[v_LegacyWaveform] AS [WF1]
    INNER JOIN [dbo].[v_LegacyWaveform] AS [WF2] ON [WF1].[PatientId] = [WF2].[PatientId]
                                                    AND [WF1].[TypeId] = [WF2].[TypeId]
                                                    AND [WF1].[TopicSessionId] <> [WF2].[TopicSessionId]
                                                    AND [WF1].[SessionBeginUTC] <= [WF2].[SessionBeginUTC]
                                                    AND [WF2].[TimeStampBeginUTC] < [WF1].[TimeStampEndUTC]
                                                    AND [WF1].[TimeStampBeginUTC] < [WF2].[TimeStampEndUTC];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_DiscardedOverlappingWaveformData';

