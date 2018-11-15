CREATE VIEW [dbo].[v_PatientSessionOrganization]
WITH
     SCHEMABINDING
AS
SELECT DISTINCT
    [PatientData].[PatientSessionId],
    [OrganizationId] AS [UnitId]
FROM
    [dbo].[PatientData]
    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[PatientSessionId] = [PatientData].[PatientSessionId]
    INNER JOIN [dbo].[DeviceSessions] ON [DeviceSessions].[Id] = [TopicSessions].[DeviceSessionId]
    INNER JOIN [dbo].[v_DeviceSessionOrganization] ON [v_DeviceSessionOrganization].[DeviceSessionId] = [DeviceSessions].[Id];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PatientSessionOrganization';

