CREATE VIEW [dbo].[v_LegacyPatientMonitor]
WITH
     SCHEMABINDING
AS
SELECT DISTINCT
    [v_PatientTopicSessions].[PatientId] AS [PatientId],
    [DeviceSessions].[DeviceId],
    [DeviceSessions].[Id] AS [DeviceSessionsId],
    [DeviceSessions].[Id] AS [EncounterId],
    [DeviceSessions].[BeginTimeUTC] AS [SessionStartTimeUTC]
FROM
    [dbo].[TopicSessions]
    INNER JOIN [dbo].[DeviceSessions] ON [TopicSessions].[DeviceSessionId] = [DeviceSessions].[Id]
    INNER JOIN [dbo].[v_PatientTopicSessions] ON [v_PatientTopicSessions].[TopicSessionId] = [TopicSessions].[Id];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LegacyPatientMonitor';

