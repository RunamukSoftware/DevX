CREATE VIEW [old].[vwLegacyPatientMonitor]
WITH SCHEMABINDING
AS
    SELECT DISTINCT
        [vpts].[PatientID],
        [ds].[DeviceID],
        [ds].[DeviceSessionID],
        [ds].[DeviceSessionID] AS [EncounterID],
        [ds].[BeginDateTime]   AS [SessionStartTime]
    FROM
        [old].[TopicSession]               AS [ts]
        INNER JOIN
            [old].[DeviceSession]          AS [ds]
                ON [ts].[DeviceSessionID] = [ds].[DeviceSessionID]
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyPatientMonitor';

