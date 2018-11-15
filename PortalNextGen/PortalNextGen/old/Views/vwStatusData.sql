CREATE VIEW [old].[vwStatusData]
WITH SCHEMABINDING
AS
    SELECT
        [sd].[StatusID],
        [sd].[SetID],
        [sd].[Name],
        [sd].[Value]       AS [ResultValue],
        [ts].[TopicTypeID],
        [ts].[TopicSessionID],
        [sds].[Timestamp],
        [vpts].[PatientID],
        CASE [sd].[Name]
            WHEN 'lead1Index'
                THEN '2.1.2.0'
            WHEN 'lead2Index'
                THEN '2.2.2.0'
            ELSE
                [sd].[Name]
        END                AS [GlobalDataSystemCode],
        [sds].[FeedTypeID] AS [FeedTypeID]
    FROM
        [old].[Status]                 AS [sd]
        INNER JOIN
            [old].[StatusSet]         AS [sds]
                ON [sd].[SetID] = [sds].[StatusSetID]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [sds].[TopicSessionID]
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwStatusData';

