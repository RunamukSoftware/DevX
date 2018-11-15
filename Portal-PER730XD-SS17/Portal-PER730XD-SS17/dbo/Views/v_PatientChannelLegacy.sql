CREATE VIEW [dbo].[v_PatientChannelLegacy]
WITH
     SCHEMABINDING
AS
SELECT
    [DeviceSessionId] AS [DeviceSessionId],
    [PatientId],
    [DeviceId],
    [TypeId],
    [TopicTypeId],
    ISNULL([TypeId], [TopicTypeId]) AS [ChannelTypeId],
    [Active]
FROM
    [dbo].[v_AvailableDataTypes]
    INNER JOIN [dbo].[DeviceSessions] ON [Id] = [DeviceSessionId];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PatientChannelLegacy';

