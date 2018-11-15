CREATE VIEW [dbo].[v_PatientSessions]
WITH
     SCHEMABINDING
AS
SELECT
    [LatestPatientSessionAssignment].[PatientId] AS [patient_id],
    ISNULL([int_person].[last_nm], '') + ', ' + ISNULL([int_person].[first_nm], '') AS [patient_name],
    [int_person].[first_nm] AS [FIRST_NAME],
    [int_person].[middle_nm] AS [MIDDLE_NAME],
    [int_person].[last_nm] AS [LAST_NAME],
    CASE 
        WHEN [Assignment].[BedName] IS NULL
              OR [Assignment].[MonitorName] IS NULL THEN [Devices].[Name]
        ELSE RTRIM([Assignment].[BedName]) + '(' + RTRIM([Assignment].[Channel]) + ')'
    END AS [MONITOR_NAME],
    [Units].[organization_nm] AS [UNIT_NAME],
    [Units].[organization_cd] AS [UNIT_CODE],
    [Units].[organization_id] AS [UNIT_ID],
    [Facilities].[organization_nm] AS [FACILITY_NAME],
    [Facilities].[organization_cd] AS [FACILITY_CODE],
    [Facilities].[organization_id] AS [FACILITY_ID],
    [int_mrn_map].[mrn_xid2] AS [ACCOUNT_ID],
    [int_mrn_map].[mrn_xid] AS [MRN_ID],
    [int_patient].[dob] AS [DOB],
    [PatientSessions].[BeginTimeUTC] AS [ADMIT_TIME_UTC],
    [PatientSessions].[EndTimeUTC] AS [DISCHARGED_TIME_UTC],
    [tsmax].[MaxTime] AS [LAST_RESULT_UTC],
    [PatientSessions].[Id] AS [PATIENT_MONITOR_ID],
    CASE 
        WHEN [PatientSessions].[EndTimeUTC] IS NULL AND ISNULL([MonitoringStatusSequence].[Value], N'Normal') <> N'Standby' THEN 'A'
        WHEN [PatientSessions].[EndTimeUTC] IS NULL AND ISNULL([MonitoringStatusSequence].[Value], N'Normal') =  N'Standby' THEN 'S'
        ELSE 'D'
    END AS [STATUS],
    [Facilities].[parent_organization_id] AS [FACILITY_PARENT_ID],
    [Devices].[Room] AS [ROOM],
    [Assignment].[BedName] AS [BED],
    CAST(NULL AS NVARCHAR) AS [SUBNET],
    [DeviceSessions].[DeviceId] AS [DeviceId]
FROM
    [dbo].[PatientSessions] -- From the patient session, get to the patient
    INNER JOIN (SELECT
                    [PatientSessionId],
                    [PatientId]
                FROM
                    (SELECT
                        [PatientSessionId],
                        [PatientId],
                        ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [Sequence] DESC) AS [RowNumber]
                     FROM
                        [dbo].[PatientSessionsMap]
                    ) AS [PatientSessionsAssignmentSequence]
                WHERE
                    [PatientSessionsAssignmentSequence].[RowNumber] = 1
               ) AS [LatestPatientSessionAssignment] ON [LatestPatientSessionAssignment].[PatientSessionId] = [PatientSessions].[Id]

    -- From the patient session, get to the device and ID1
    INNER JOIN (SELECT
                    [PatientSessionId],
                    [DeviceSessionId]
                FROM
                    (SELECT
                        [PatientSessionId],
                        [DeviceSessionId],
                        ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [TimestampUTC] DESC) AS [RowNumber]
                     FROM
                        [dbo].[PatientData]
                    ) AS [PatientSessionsDeviceSequence]
                WHERE
                    [PatientSessionsDeviceSequence].[RowNumber] = 1
               ) AS [LatestPatientSessionDevice] ON [LatestPatientSessionDevice].[PatientSessionId] = [PatientSessions].[Id]
    INNER JOIN [dbo].[DeviceSessions] ON [DeviceSessions].[Id] = [LatestPatientSessionDevice].[DeviceSessionId]
    INNER JOIN [dbo].[Devices] ON [DeviceSessions].[DeviceId] = [Devices].[Id]

    -- From the device, get to the facility and units
    INNER JOIN [dbo].[v_DeviceSessionAssignment] AS [Assignment] ON [Assignment].[DeviceSessionId] = [LatestPatientSessionDevice].[DeviceSessionId]
    LEFT OUTER JOIN [dbo].[int_organization] AS [Facilities] ON [Facilities].[organization_nm] = [Assignment].[FacilityName]
                                                                AND [Facilities].[category_cd] = 'F'
    LEFT OUTER JOIN [dbo].[int_organization] AS [Units] ON [Units].[organization_nm] = [Assignment].[UnitName]
                                                           AND [Units].[parent_organization_id] = [Facilities].[organization_id]
    LEFT OUTER JOIN [dbo].[int_mrn_map] ON [int_mrn_map].[patient_id] = [LatestPatientSessionAssignment].[PatientId]
                                           AND [int_mrn_map].[merge_cd] = 'C'
    LEFT OUTER JOIN [dbo].[int_patient] ON [int_patient].[patient_id] = [LatestPatientSessionAssignment].[PatientId]
    LEFT OUTER JOIN [dbo].[int_person] ON [int_person].[person_id] = [LatestPatientSessionAssignment].[PatientId]
    LEFT OUTER JOIN
    (
        SELECT [DeviceSessionId],
               [Value],
               ROW_NUMBER() OVER (PARTITION BY [DeviceSessionId] ORDER BY [TimestampUTC] DESC) AS [RowNumber]
        FROM [dbo].[DeviceInfoData]
        WHERE [Name]=N'MonitoringStatus'
    ) AS [MonitoringStatusSequence] ON [MonitoringStatusSequence].[DeviceSessionId]=[DeviceSessions].[Id] AND [MonitoringStatusSequence].[RowNumber]=1
    INNER JOIN (SELECT
                    [PatientSessionId],
                    MAX([vd].[MaxTime]) AS [MaxTime]
                FROM
                    [dbo].[TopicSessions]
                    LEFT OUTER JOIN (SELECT
                                        [TopicSessionId],
                                        MAX([TimestampUTC]) AS [MaxTime]
                                     FROM
                                        [dbo].[VitalsData]
                                     GROUP BY
                                        [TopicSessionId]
                                    ) AS [vd] ON [vd].[TopicSessionId] = [TopicSessions].[Id]
                GROUP BY
                    [PatientSessionId]
               ) AS [tsmax] ON [PatientSessions].[Id] = [tsmax].[PatientSessionId];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_PatientSessions';

