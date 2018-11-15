CREATE VIEW [old].[vwPatientChannelLegacy]
WITH SCHEMABINDING
AS
    SELECT
        [vadt].[DeviceSessionID],
        [vadt].[PatientID],
        [ds].[DeviceID],
        [vadt].[TypeID],
        [vadt].[TopicTypeID],
        ISNULL([vadt].[TypeID], [vadt].[TopicTypeID]) AS [ChannelTypeID],
        [vadt].[Active]
    FROM
        [old].[vwAvailableDataTypes] AS [vadt]
        INNER JOIN
            [old].[DeviceSession]    AS [ds]
                ON [ds].[DeviceSessionID] = [vadt].[DeviceSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatientChannelLegacy';

