CREATE VIEW [dbo].[v_PatientTopicSessions]
WITH
     SCHEMABINDING
AS
SELECT
    [TopicSessions].[Id] AS [TopicSessionId],
    [PatientMap].[PatientId]
FROM
    [dbo].[PatientSessionsMap] AS [PatientMap]
    INNER JOIN (SELECT
                    [PatientSessionId],
                    MAX([Sequence]) AS [MaxSequence]
                FROM
                    [dbo].[PatientSessionsMap]
                GROUP BY
                    [PatientSessionId]
               ) AS [PatientMax] ON [PatientMax].[PatientSessionId] = [PatientMap].[PatientSessionId]
                                    AND [PatientMax].[MaxSequence] = [PatientMap].[Sequence]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[PatientSessionId] = [PatientMap].[PatientSessionId];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PatientTopicSessions';

