CREATE VIEW [old].[vwPatientSessions]
WITH SCHEMABINDING
AS
    SELECT
            [LatestPatientSessionAssignment].[PatientID],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [ipe].[LastName],
            CASE
                WHEN [Assignment].[BedName] IS NULL
                     OR [Assignment].[MonitorName] IS NULL
                    THEN [d].[Name]
                ELSE
                    RTRIM([Assignment].[BedName]) + N'(' + RTRIM([Assignment].[Channel]) + N')'
            END                                 AS [MonitorName],
            [Units].[OrganizationName]          AS [UnitName],
            [Units].[OrganizationCode]          AS [UnitCode],
            [Units].[OrganizationID]            AS [UnitID],
            [Facilities].[OrganizationName]     AS [FacilityName],
            [Facilities].[OrganizationCode]     AS [FacilityCode],
            [Facilities].[OrganizationID]       AS [FacilityID],
            [imm].[MedicalRecordNumberXID2]     AS [AccountID],
            [imm].[MedicalRecordNumberXID]      AS [MedicalRecordNumberID],
            [ipa].[DateOfBirth],
            [ps].[BeginDateTime]                AS [AdmitDateTime],
            [ps].[EndDateTime]                  AS [DischargedDateTime],
            [tsmax].[MaxTime]                   AS [LastResultDateTime],
            [ps].[PatientSessionID]             AS [PatientMonitorID],
            CASE
                WHEN [ps].[EndDateTime] IS NULL
                     AND ISNULL([MonitoringStatusSequence].[Value], N'Normal') <> N'Standby'
                    THEN 'A'
                WHEN [ps].[EndDateTime] IS NULL
                     AND ISNULL([MonitoringStatusSequence].[Value], N'Normal') = N'Standby'
                    THEN 'S'
                ELSE
                    'D'
            END                                 AS [Status],
            [Facilities].[ParentOrganizationID] AS [FacilityParentID],
            [d].[Room],
            [Assignment].[BedName]              AS [Bed],
            CAST(NULL AS NVARCHAR)              AS [Subnet],
            [d].[DeviceID]
    FROM
            [old].[PatientSession]             AS [ps] -- From the patient session, get to the patient
        INNER JOIN
            (
                SELECT
                    [PatientSessionsAssignmentSequence].[PatientSessionID],
                    [PatientSessionsAssignmentSequence].[PatientID]
                FROM
                    (
                        SELECT
                            [psm].[PatientSessionID],
                            [psm].[PatientID],
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [psm].[PatientSessionID]
                                               ORDER BY
                                                   [psm].[PatientSessionMapID] DESC
                                              ) AS [RowNumber]
                        FROM
                            [old].[PatientSessionMap] AS [psm]
                    ) AS [PatientSessionsAssignmentSequence]
                WHERE
                    [PatientSessionsAssignmentSequence].[RowNumber] = 1
            )                                  AS [LatestPatientSessionAssignment]
                ON [LatestPatientSessionAssignment].[PatientSessionID] = [ps].[PatientSessionID]

        -- From the patient session, get to the device and ID1
        INNER JOIN
            (
                SELECT
                    [PatientSessionsDeviceSequence].[PatientSessionID],
                    [PatientSessionsDeviceSequence].[DeviceSessionID]
                FROM
                    (
                        SELECT
                            [pd].[PatientSessionID],
                            [pd].[DeviceSessionID],
                            ROW_NUMBER() OVER (PARTITION BY
                                                   [pd].[PatientSessionID]
                                               ORDER BY
                                                   [pd].[Timestamp] DESC
                                              ) AS [RowNumber]
                        FROM
                            [old].[Patient] AS [pd]
                    ) AS [PatientSessionsDeviceSequence]
                WHERE
                    [PatientSessionsDeviceSequence].[RowNumber] = 1
            )                                  AS [LatestPatientSessionDevice]
                ON [LatestPatientSessionDevice].[PatientSessionID] = [ps].[PatientSessionID]
        INNER JOIN
            [old].[DeviceSession]              AS [ds]
                ON [ds].[DeviceSessionID] = [LatestPatientSessionDevice].[DeviceSessionID]
        INNER JOIN
            [old].[Device]                     AS [d]
                ON [ds].[DeviceID] = [d].[DeviceID]
        -- From the device, get to the facility and units
        INNER JOIN
            [old].[vwDeviceSessionAssignment]  AS [Assignment]
                ON [Assignment].[DeviceSessionID] = [LatestPatientSessionDevice].[DeviceSessionID]
        LEFT OUTER JOIN
            [Intesys].[Organization]           AS [Facilities]
                ON [Facilities].[OrganizationName] = [Assignment].[FacilityName]
                   AND [Facilities].[CategoryCode] = 'F'
        LEFT OUTER JOIN
            [Intesys].[Organization]           AS [Units]
                ON [Units].[OrganizationName] = [Assignment].[UnitName]
                   AND [Units].[ParentOrganizationID] = [Facilities].[OrganizationID]
        LEFT OUTER JOIN
            [Intesys].[MedicalRecordNumberMap] AS [imm]
                ON [imm].[PatientID] = [LatestPatientSessionAssignment].[PatientID]
                   AND [imm].[MergeCode] = 'C'
        LEFT OUTER JOIN
            [Intesys].[Patient]                AS [ipa]
                ON [ipa].[PatientID] = [LatestPatientSessionAssignment].[PatientID]
        LEFT OUTER JOIN
            [Intesys].[Person]                 AS [ipe]
                ON [ipe].[PersonID] = [LatestPatientSessionAssignment].[PatientID]
        LEFT OUTER JOIN
            (
                SELECT
                    [did].[DeviceSessionID],
                    [did].[Value],
                    ROW_NUMBER() OVER (PARTITION BY
                                           [did].[DeviceSessionID]
                                       ORDER BY
                                           [did].[DateTimeStamp] DESC
                                      ) AS [RowNumber]
                FROM
                    [old].[DeviceInformation] AS [did]
                WHERE
                    [did].[Name] = N'MonitoringStatus'
            )                                  AS [MonitoringStatusSequence]
                ON [MonitoringStatusSequence].[DeviceSessionID] = [ds].[DeviceSessionID]
                   AND [MonitoringStatusSequence].[RowNumber] = 1
        INNER JOIN
            (
                SELECT
                        [ts].[PatientSessionID],
                        MAX([vd].[MaxTime]) AS [MaxTime]
                FROM
                        [old].[TopicSession] AS [ts]
                    LEFT OUTER JOIN
                        (
                            SELECT
                                [vd2].[TopicSessionID],
                                MAX([vd2].[Timestamp]) AS [MaxTime]
                            FROM
                                [old].[Vital] AS [vd2]
                            GROUP BY
                                [vd2].[TopicSessionID]
                        )                    AS [vd]
                            ON [vd].[TopicSessionID] = [ts].[TopicSessionID]
                GROUP BY
                        [ts].[PatientSessionID]
            )                                  AS [tsmax]
                ON [ps].[PatientSessionID] = [tsmax].[PatientSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatientSessions';

