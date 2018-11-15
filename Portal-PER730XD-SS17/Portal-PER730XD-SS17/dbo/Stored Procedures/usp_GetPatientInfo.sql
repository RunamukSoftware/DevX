CREATE PROCEDURE [dbo].[usp_GetPatientInfo]
    (
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [int_mrn_map].[mrn_xid],
        [int_mrn_map].[mrn_xid2],
        [int_person].[last_nm],
        [int_person].[first_nm],
        [int_person].[middle_nm],
        [int_patient].[dob],
        [int_misc_code].[short_dsc],
        [int_patient].[height],
        [int_patient].[weight],
        [int_patient].[bsa],
        [org1].[organization_cd] + N' - ' + [org2].[organization_cd] AS [Unit],
        [int_encounter].[rm],
        [int_encounter].[bed],
        [int_encounter_map].[encounter_xid],
        CAST(0 AS TINYINT) AS [IsDataLoader],
        [int_patient_monitor].[last_result_dt] AS [Precedence]
    FROM
        [dbo].[int_encounter]
        LEFT OUTER JOIN [dbo].[int_organization] AS [org1] ON ([int_encounter].[organization_id] = [org1].[organization_id])
        LEFT OUTER JOIN [dbo].[int_patient_monitor]
        INNER JOIN [dbo].[int_monitor] ON ([dbo].[int_patient_monitor].[monitor_id] = [int_monitor].[monitor_id]) ON ([int_encounter].[encounter_id] = [dbo].[int_patient_monitor].[encounter_id])
                                                                                                               AND ([int_encounter].[patient_id] = [dbo].[int_patient_monitor].[patient_id])
        INNER JOIN [dbo].[int_encounter_map] ON ([int_encounter].[encounter_id] = [int_encounter_map].[encounter_id])
        INNER JOIN [dbo].[int_person] ON ([int_encounter].[patient_id] = [int_person].[person_id])
        INNER JOIN [dbo].[int_patient] ON ([int_person].[person_id] = [int_patient].[patient_id])
        INNER JOIN [dbo].[int_mrn_map] ON ([int_patient].[patient_id] = [int_mrn_map].[patient_id])
        INNER JOIN [dbo].[int_organization] AS [org2] ON ([int_encounter].[unit_org_id] = [org2].[organization_id])
        LEFT OUTER JOIN [dbo].[int_misc_code] ON [int_patient].[gender_cid] = [int_misc_code].[code_id]
    WHERE
        [int_mrn_map].[merge_cd] = 'C'
        AND [int_mrn_map].[patient_id] = @PatientId

    UNION

    SELECT
        [int_mrn_map].[mrn_xid],
        [int_mrn_map].[mrn_xid2],
        [int_person].[last_nm],
        [int_person].[first_nm],
        [int_person].[middle_nm],
        [int_patient].[dob],
        [int_misc_code].[short_dsc],
        [int_patient].[height],
        [int_patient].[weight],
        [int_patient].[bsa],
        [Facilities].[organization_cd] + N' - ' + [Units].[organization_cd] AS [Unit],
        [Devices].[Room] AS [rm],
        [Assignment].[BedName] AS [bed],
        [encounter_xid] = CAST(NULL AS NVARCHAR(40)),
        [IsDataLoader] = CAST(1 AS TINYINT),
        --[dbo].[fnUtcDateTimeToLocalTime]([PatientSessions].[BeginTimeUTC]) AS [Precedence]
        [Precedence].[LocalDateTime] AS [Precedence]
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
        LEFT OUTER JOIN [dbo].[int_misc_code] ON [int_misc_code].[code_id] = [int_patient].[gender_cid]
        CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([PatientSessions].[BeginTimeUTC]) AS [Precedence]
    WHERE
        [LatestPatientSessionAssignment].[PatientId] = @PatientId

    ORDER BY
        [Precedence] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inline queries to SPs/ICS Admin Component.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetPatientInfo';

