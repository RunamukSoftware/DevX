CREATE VIEW [old].[vwVitalsData]
WITH SCHEMABINDING
AS
    SELECT
        [vd].[VitalID],
        [vd].[SetID],
        [vd].[Name],
        [vd].[Value]        AS [ResultValue],
        [ts].[TopicTypeID],
        [ts].[TopicSessionID],
        [vd].[Timestamp] AS [DateTimeStamp],
        [vpts].[PatientID],
        [gcm].[GlobalDataSystemCode],
        [vd].[FeedTypeID]
    FROM
        [old].[Vital]                      AS [vd]
        INNER JOIN
            [old].[GlobalDataSystemCodeMap]             AS [gcm]
                ON [gcm].[FeedTypeID] = [vd].[FeedTypeID]
                   AND [gcm].[Name] = [vd].[Name]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [vd].[TopicSessionID]
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets the vitals data.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwVitalsData';

