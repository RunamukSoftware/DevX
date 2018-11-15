CREATE VIEW [old].[vwCombinedEncounters]
WITH SCHEMABINDING
AS
    SELECT
        [vps].[FirstName],
        [vps].[LastName],
        [vps].[MedicalRecordNumberID],
        [vps].[AccountID],
        [vps].[DateOfBirth],
        [vps].[FacilityID],
        [vps].[UnitID],
        [vps].[Room],
        [vps].[Bed],
        [vps].[MonitorName],
        [vps].[LastResultDateTime],
        [vps].[AdmitDateTime],
        [vps].[DischargedDateTime],
        [vps].[Subnet],
        [vps].[PatientID],
        CASE [vps].[Status]
            WHEN 'A'
                THEN 'C'
            WHEN 'S'
                THEN 'C'
            ELSE
                'D'
        END                         AS [StatusCode],
        1                           AS [MonitorCreated],
        [io].[ParentOrganizationID] AS [FacilityParentID],
        [vps].[PatientMonitorID],
        'C'                         AS [MergeCode]
    FROM
        [old].[vwPatientSessions]    AS [vps]
        INNER JOIN
            [Intesys].[Organization] AS [io]
                ON [io].[OrganizationID] = [vps].[FacilityID]
    UNION ALL
    SELECT
        ISNULL([ipe].[FirstName], N''),
        ISNULL([ipe].[LastName], N''),
        [imm].[MedicalRecordNumberXID]  AS [MedicalRecordNumberID],
        [imm].[MedicalRecordNumberXID2] AS [AccountID],
        [ipa].[DateOfBirth]             AS [DateOfBirth],
        [org1].[OrganizationID]         AS [FacilityID],
        [org2].[OrganizationID]         AS [UnitID],
        [ie].[Room]                     AS [Room],
        [ie].[Bed]                      AS [Bed],
        [im].[MonitorName]              AS [MonitorName],
        [PM1].[LastResultDateTime]      AS [LastResult],
        [ie].[AdmitDateTime]            AS [Admit],
        [ie].[DischargeDateTime]        AS [Discharged],
        [im].[Subnet]                   AS [Subnet],
        [imm].[PatientID]               AS [PatientID],
        [ie].[StatusCode]               AS [StatusCode],
        [ie].[MonitorCreated]           AS [MonitorCreated],
        [org1].[ParentOrganizationID]   AS [FacilityParentID],
        [PM1].[PatientMonitorID]        AS [PatientMonitorID],
        [imm].[MergeCode]               AS [MergeCode]
    FROM
        [Intesys].[Encounter]                  AS [ie]
        LEFT OUTER JOIN
            [Intesys].[Organization]           AS [org1]
                ON [ie].[OrganizationID] = [org1].[OrganizationID]
        LEFT OUTER JOIN
            [Intesys].[PatientMonitor] AS [PM1]
            INNER JOIN
                [Intesys].[Monitor]    AS [im]
                    ON [PM1].[MonitorID] = [im].[MonitorID]
                ON [ie].[EncounterID] = [PM1].[EncounterID]
        LEFT OUTER JOIN
            [Intesys].[PatientMonitor]         AS [PM2]
                ON [PM2].[PatientMonitorID] <> [PM1].[PatientMonitorID]
                   AND [ie].[EncounterID] = [PM2].[EncounterID]
                   AND [PM1].[LastResultDateTime] < [PM2].[LastResultDateTime]
        INNER JOIN
            [Intesys].[Person]                 AS [ipe]
                ON [ie].[PatientID] = [ipe].[PersonID]
        INNER JOIN
            [Intesys].[Patient]                AS [ipa]
                ON [ipe].[PersonID] = [ipa].[PatientID]
        INNER JOIN
            [Intesys].[MedicalRecordNumberMap] AS [imm]
                ON [ipa].[PatientID] = [imm].[PatientID]
        INNER JOIN
            [Intesys].[Organization]           AS [org2]
                ON [ie].[UnitOrganizationID] = [org2].[OrganizationID]
    WHERE
        [PM2].[EncounterID] IS NULL;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwCombinedEncounters';

