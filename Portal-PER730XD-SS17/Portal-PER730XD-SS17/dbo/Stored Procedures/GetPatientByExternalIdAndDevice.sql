CREATE PROCEDURE [dbo].[GetPatientByExternalIdAndDevice]
  (
  @mrn_id AS NVARCHAR(30),
  @device AS NVARCHAR(30) = NULL,
  @login_name                    NVARCHAR(64),
  @is_vip_searchable             NVARCHAR(4),
  @is_restricted_unit_searchable NVARCHAR(4)
  )
AS
BEGIN
    SELECT int_mrn_map.patient_id AS [PATIENT_ID],
           CONCAT(int_person.last_nm, N', ', int_person.first_nm) AS PATIENT_NAME,
           int_monitor.monitor_name AS [MONITOR_NAME],
           int_mrn_map.mrn_xid2 AS ACCOUNT_ID,
           int_mrn_map.mrn_xid AS MRN_ID,
           ORG1.organization_id AS UNIT_ID,
           ORG1.organization_cd AS UNIT_NAME,
           ORG2.organization_id AS FACILITY_ID,
           ORG2.organization_nm AS FACILITY_NAME,
           int_patient.dob AS DOB,
           int_encounter.admit_dt AS ADMIT_TIME,
           int_encounter.discharge_dt AS DISCHARGED_TIME,
           int_patient_monitor.patient_monitor_id AS PATIENT_MONITOR_ID,
            STATUS = case  
                WHEN int_encounter.discharge_dt IS NULL 
              THEN 'A'
                  ELSE 'D'
            END
        FROM [dbo].int_mrn_map
        INNER JOIN [dbo].int_patient_monitor ON int_patient_monitor.patient_id=int_mrn_map.patient_id
        INNER JOIN [dbo].int_encounter
            ON int_encounter.encounter_id=int_patient_monitor.encounter_id
            AND (@is_vip_searchable = '1' OR int_encounter.vip_sw IS NULL)
        INNER JOIN [dbo].int_monitor
            ON int_monitor.monitor_id=int_patient_monitor.monitor_id
            AND (@device IS NULL OR int_monitor.node_id=@device)
        LEFT OUTER JOIN [dbo].int_person ON int_person.person_id=int_mrn_map.patient_id
        LEFT OUTER JOIN [dbo].int_patient ON int_patient.patient_id=int_mrn_map.patient_id
        INNER JOIN [dbo].int_organization  AS ORG1
            ON (int_monitor.unit_org_id = ORG1.organization_id)
            AND (
                    @is_restricted_unit_searchable = '1'
                OR
                    ORG1.organization_id NOT IN
                    (
                        SELECT organization_id
                            FROM dbo.cdr_restricted_organization
                            WHERE user_role_id = (SELECT user_role_id FROM dbo.int_user WHERE login_name = @login_name)
                    )
            )	
        LEFT OUTER JOIN [dbo].int_organization AS ORG2 ON ORG2.organization_id=ORG1.parent_organization_id
        WHERE mrn_xid = @mrn_id
        AND merge_cd = 'C'

UNION ALL

    SELECT
        [PATIENT_ID]         = [int_mrn_map].[patient_id],
        [PATIENT_NAME]       = CONCAT(int_person.last_nm, N', ', int_person.first_nm),
        [MONITOR_NAME]       = 
        CASE WHEN [Assignment].[BedName] IS NULL OR [Assignment].[MonitorName] IS NULL THEN [Devices].[Name]
            ELSE RTRIM([Assignment].[BedName]) + '(' + RTRIM([Assignment].[Channel]) + ')'
        END,
        [ACCOUNT_ID]         = [int_mrn_map].[mrn_xid2],
        [MRN_ID]             = [int_mrn_map].[mrn_xid],
        [UNIT_ID]			= [Units].[organization_id],
        [UNIT_NAME]			= [Units].[organization_nm],
        [FACILITY_ID]		= [Facilities].[organization_id],
        [FACILITY_NAME]		= [Facilities].[organization_nm],
        [DOB]                = [int_patient].[dob],
        --[ADMIT_TIMEC]     = dbo.[fnUtcDateTimeToLocalTime]([PatientSessions].[BeginTimeUTC]),
        --[DISCHARGED_TIME]= dbo.[fnUtcDateTimeToLocalTime]([PatientSessions].[EndTimeUTC]),
        [ADMIT_TIMEC].[LocalDateTime] AS [ADMIT_TIMEC],
        [DISCHARGED_TIME].[LocalDateTime] AS [DISCHARGED_TIME],
        [PATIENT_MONITOR_ID] = [PatientSessions].[Id],
        [STATUS] = CASE WHEN [PatientSessions].[EndTimeUTC] IS NULL THEN 'A' ELSE 'D' END
        FROM [dbo].[int_mrn_map]
        INNER JOIN [dbo].[PatientSessionsMap] ON [PatientSessionsMap].[PatientId]=[int_mrn_map].[patient_id]
        INNER JOIN
        (
            SELECT [PatientSessionId], [MaxSeq] = MAX(Sequence)
                FROM [dbo].[PatientSessionsMap]
                GROUP BY [PatientSessionId]
        ) AS [PatientSessionMaxSeq] ON [PatientSessionMaxSeq].[PatientSessionId]=[PatientSessionsMap].[PatientSessionId]
        AND [PatientSessionMaxSeq].[MaxSeq]=[PatientSessionsMap].[Sequence]
        INNER JOIN [dbo].[PatientSessions] ON [PatientSessions].[Id]=[PatientSessionsMap].[PatientSessionId]
            INNER JOIN
        (
        SELECT [PatientSessionId]
            ,[DeviceSessionId]
        FROM
        (
        SELECT [PatientSessionId]
            ,[DeviceSessionId]
            ,[R] = ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [TimestampUTC] DESC)
            FROM [dbo].[PatientData]
        ) AS [PatientSessionsDeviceSequence]
        WHERE [R]=1
        ) 
        AS [LatestPatientSessionDevice]
            ON [LatestPatientSessionDevice].[PatientSessionId] = [PatientSessions].[Id]
        INNER JOIN [dbo].[DeviceSessions] 
            ON [DeviceSessions].[Id] = [LatestPatientSessionDevice].[DeviceSessionId]
        INNER JOIN [dbo].[Devices] 
            ON [DeviceSessions].[DeviceId] = [Devices].[Id]
            AND (@device IS NULL OR Devices.Name=@device)
        INNER JOIN [dbo].[v_DeviceSessionAssignment] [Assignment] 
            ON [Assignment].[DeviceSessionId] = [LatestPatientSessionDevice].[DeviceSessionId]
        LEFT OUTER JOIN [dbo].[int_organization] AS [Facilities]
            ON [Facilities].[organization_nm] = [Assignment].[FacilityName]
                AND [Facilities].[category_cd]='F'
        LEFT OUTER JOIN [dbo].[int_organization] AS [Units]
            ON [Units].[organization_nm] = [Assignment].[UnitName] 
                AND [Units].[parent_organization_id] = [Facilities].[organization_id]
                AND (
                    @is_restricted_unit_searchable = '1'
                OR
                    [Units].organization_id NOT IN
                    (
                        SELECT organization_id
                            FROM dbo.cdr_restricted_organization
                            WHERE user_role_id = (SELECT user_role_id FROM dbo.int_user WHERE login_name = @login_name)
                    )
                )	
        LEFT OUTER JOIN [dbo].[int_patient] 
            ON [int_patient].[patient_id] = [int_mrn_map].[patient_id]
        LEFT OUTER JOIN [dbo].[int_person] 
            ON [int_person].[person_id] = [int_mrn_map].[patient_id]
        CROSS APPLY dbo.[fntUtcDateTimeToLocalTime]([PatientSessions].[BeginTimeUTC]) AS [ADMIT_TIMEC]
        CROSS APPLY dbo.[fntUtcDateTimeToLocalTime]([PatientSessions].[EndTimeUTC]) AS [DISCHARGED_TIME]
        WHERE mrn_xid= @mrn_id
        AND merge_cd='C'

ORDER BY 
    [ADMIT_TIME] DESC, 
    [STATUS],
    [PATIENT_NAME],
    [MONITOR_NAME]
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient information by the external medical record ID and device name.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientByExternalIdAndDevice';

