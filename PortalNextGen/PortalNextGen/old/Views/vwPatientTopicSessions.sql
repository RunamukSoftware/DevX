CREATE VIEW [old].[vwPatientTopicSessions]
WITH SCHEMABINDING
AS
    SELECT
        [ts].[TopicSessionID],
        [psm].[PatientID]
    FROM
        [old].[PatientSessionMap] AS [psm]
        INNER JOIN
            (
                SELECT
                    [psm].[PatientSessionID],
                    MAX([psm].[PatientSessionMapID]) AS [MaxSequence]
                FROM
                    [old].[PatientSessionMap] AS [psm]
                GROUP BY
                    [psm].[PatientSessionID]
            )                     AS [PatientMax]
                ON [PatientMax].[PatientSessionID] = [psm].[PatientSessionID]
                   AND [PatientMax].[MaxSequence] = [psm].[PatientSessionMapID]
        INNER JOIN
            [old].[TopicSession]  AS [ts]
                ON [ts].[PatientSessionID] = [psm].[PatientSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatientTopicSessions';

