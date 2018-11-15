CREATE VIEW [old].[vwPatientSessionOrganization]
WITH SCHEMABINDING
AS
    SELECT DISTINCT
        [pd].[PatientSessionID],
        [vdso].[OrganizationID] AS [UnitID]
    FROM
        [old].[Patient]                     AS [pd]
        INNER JOIN
            [old].[TopicSession]                AS [ts]
                ON [ts].[PatientSessionID] = [pd].[PatientSessionID]
        INNER JOIN
            [old].[DeviceSession]               AS [ds]
                ON [ds].[DeviceSessionID] = [ts].[DeviceSessionID]
        INNER JOIN
            [old].[vwDeviceSessionOrganization] AS [vdso]
                ON [vdso].[DeviceSessionID] = [ds].[DeviceSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatientSessionOrganization';

