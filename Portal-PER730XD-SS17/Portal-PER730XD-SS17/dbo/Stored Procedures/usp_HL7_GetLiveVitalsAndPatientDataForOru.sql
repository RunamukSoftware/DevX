CREATE PROCEDURE [dbo].[usp_HL7_GetLiveVitalsAndPatientDataForOru]
AS
BEGIN
    DECLARE @SelectedPatients TABLE
        (
         [PatientId] UNIQUEIDENTIFIER
        );

    DECLARE @LastRunDateTime DATETIME;

    SELECT
        @LastRunDateTime = DATEADD(s, -CAST([keyvalue] AS INT), GETDATE())
    FROM
        [dbo].[int_cfg_values]
    WHERE
        [keyname] = 'vitalsRefreshInterval';

    --Get all active patient Ids and their corresponding Monitor Ids
    INSERT  INTO @SelectedPatients
            ([PatientId]
            )
    (SELECT
        [MAP].[patient_id] AS [PATIENTID]
     FROM
        [dbo].[int_mrn_map] AS [MAP]
        INNER JOIN [dbo].[int_patient_monitor] AS [PATMON] ON [PATMON].[patient_id] = [MAP].[patient_id]
        INNER JOIN [dbo].[int_monitor] AS [MONITOR] ON [MONITOR].[monitor_id] = [PATMON].[monitor_id]
        INNER JOIN [dbo].[int_product_access] AS [ACCESS] ON [ACCESS].[organization_id] = [MONITOR].[unit_org_id]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [MONITOR].[unit_org_id]
                                                        AND [outbound_interval] > 0
        INNER JOIN [dbo].[int_encounter] AS [ENC] ON [PATMON].[encounter_id] = [ENC].[encounter_id]
     WHERE
        [merge_cd] = 'C'
        AND [ACCESS].[product_cd] = 'outHL7'
        AND [ORG].[category_cd] = 'D'
        AND ([ENC].[discharge_dt] IS NULL
        OR [ENC].[mod_dt] > @LastRunDateTime
        )
     UNION
     SELECT
        [DLPAT].[patient_id] AS [PATIENTID]
     FROM
        [dbo].[v_PatientSessions] AS [DLPAT]
        INNER JOIN [dbo].[int_product_access] AS [Access] ON [Access].[organization_id] = [DLPAT].[UNIT_ID]
        INNER JOIN [dbo].[int_organization] AS [ORG] ON [ORG].[organization_id] = [DLPAT].[UNIT_ID]
                                                        AND [outbound_interval] > 0
     WHERE
        [DLPAT].[STATUS] = 'A'
        AND [Access].[product_cd] = 'outHL7'
        AND [ORG].[category_cd] = 'D'
    );

    --Person and Patient data for PID
    DECLARE @FilterUV BIT;
    SELECT
        @FilterUV = CASE [keyvalue]
                      WHEN 'true' THEN 1
                      ELSE 0
                    END
    FROM
        [dbo].[int_cfg_values]
    WHERE
        [keyname] = 'DoNotSendUV';

    SELECT
        [Pat].[dob] AS [DateOfBirth],
        [Pat].[gender_cid] AS [GenderCd],
        [Pat].[death_dt] AS [DeathDate],
        [person].[first_nm] AS [FirstName],
        [person].[middle_nm] AS [MiddleName],
        [person].[last_nm] AS [LastName],
        [imm].[mrn_xid2] AS [AccountNumber],
        [imm].[mrn_xid] AS [MRN],
        [imm].[patient_id] AS [patient_id]
    FROM
        [dbo].[int_patient] AS [Pat]
        INNER JOIN [dbo].[int_person] AS [person] ON [Pat].[patient_id] = [person].[person_id]
                                                     AND [Pat].[patient_id] IN (SELECT
                                                                                    [PatientId]
                                                                                FROM
                                                                                    @SelectedPatients)
        INNER JOIN [dbo].[int_mrn_map] AS [imm] ON [Pat].[patient_id] = [imm].[patient_id]
    WHERE
        ([imm].[merge_cd] = 'C')
        AND ((@FilterUV = 1
        AND [mrn_xid] NOT LIKE N'UV_%'
        )
        OR (@FilterUV = 0)
        );
            
    --Get Order data
    SELECT
        [OrderNumber].[Value] AS [ORDER_ID],
		[SendingApplication].[send_app] AS [SENDING_APPLICATION],
        CAST([OrderStatus].[Value] AS INT) AS [ORDER_STATUS],
        CAST(NULL AS DATETIME) AS [ORDER_DATE_TIME],
        [Patients].[PatientId] AS [patient_id]
    FROM
        (SELECT
            [PatientId]
         FROM
            @SelectedPatients
        ) AS [Patients]
        CROSS JOIN (SELECT TOP (1)
                        [send_app]
                    FROM
                        [dbo].[int_gateway]
                   ) AS [SendingApplication]
        CROSS JOIN (SELECT
                        [Value]
                    FROM
                        [dbo].[ApplicationSettings]
                    WHERE
                        [Key] = 'DefaultFillerOrderStatus'
                   ) AS [OrderStatus]
        CROSS JOIN (SELECT
                        [Value]
                    FROM
                        [dbo].[ApplicationSettings]
                    WHERE
                        [Key] = 'DefaultFillerOrderNumber'
                   ) AS [OrderNumber];

    --Patient visit/encounter information
    SELECT DISTINCT
        [enc].[patient_type_cid] AS [PatientType],
        [enc].[med_svc_cid] AS [HospService],
        [enc].[patient_class_cid] AS [PatientClass],
        [enc].[ambul_status_cid] AS [AmbulatorySts],
        [enc].[vip_sw] AS [VipIndic],
        [enc].[discharge_dispo_cid] AS [DischDisposition],
        [enc].[admit_dt] AS [AdmitDate],
        [enc].[discharge_dt] AS [DischargeDt],
        [encmap].[encounter_xid] AS [VisitNumber],
        [enc].[patient_id] AS [patient_id],
        [encmap].[seq_no] AS [SeqNo],
        [monitor].[monitor_name] AS [NodeName],
        [monitor].[node_id] AS [NodeId],
        [monitor].[room] AS [Room],
        [monitor].[bed_cd] AS [Bed],
        [organization].[organization_cd] AS [UnitName],
        [monitor].[monitor_id] AS [DeviceId]
    FROM
        [dbo].[int_encounter] AS [enc]
        INNER JOIN [dbo].[int_encounter_map] AS [encmap] ON [enc].[encounter_id] = [encmap].[encounter_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [patMon] ON [patMon].[encounter_id] = [enc].[encounter_id]
                                                              AND (([patMon].[active_sw] = 1)
                                                              OR ([enc].[mod_dt] > @LastRunDateTime)
                                                              )
        INNER JOIN [dbo].[int_monitor] AS [monitor] ON [patMon].[monitor_id] = [monitor].[monitor_id]
        INNER JOIN [dbo].[int_organization] AS [organization] ON [organization].[organization_id] = [monitor].[unit_org_id]
    WHERE
        [patMon].[patient_id] IN (SELECT
                                    [PatientId]
                                  FROM
                                    @SelectedPatients)
    UNION ALL
    SELECT DISTINCT
        [PatientType] = CAST(NULL AS INT),
        [HospService] = CAST(NULL AS INT),
        [PatientClass] = CAST(NULL AS INT),
        [AmbulatorySts] = CAST(NULL AS INT),
        [VipIndic] = CAST(NULL AS NCHAR(2)),
        [DischDisposition] = CAST(NULL AS INT),
        [AdmitDate] = [dbo].[fnUtcDateTimeToLocalTime]([v_PatientSessions].[ADMIT_TIME_UTC]),
        [DischargeDt] = [dbo].[fnUtcDateTimeToLocalTime]([v_PatientSessions].[DISCHARGED_TIME_UTC]),
        [VisitNumber] = CAST(NULL AS NVARCHAR(40)),
        [patient_id] = [v_PatientSessions].[patient_id],
        [SeqNo] = CAST(NULL AS INT),
        [NodeName] = [v_PatientSessions].[MONITOR_NAME],
        [NodeId] = CAST(NULL AS NVARCHAR(15)),
        [Room] = [v_PatientSessions].[ROOM],
        [Bed] = [v_PatientSessions].[BED],
        [UnitName] = [v_PatientSessions].[UNIT_NAME],
        [DeviceId] = [v_PatientSessions].[DeviceId]
    FROM
        [dbo].[v_PatientSessions]
    WHERE
        [patient_id] IN (SELECT
                            [PatientId]
                         FROM
                            @SelectedPatients)
        AND [STATUS] = 'A'
    ORDER BY
        [AdmitDate] DESC;

    --Get vitals

    --for ML patients (Legacy Tele)
    SELECT DISTINCT
        [VL].[patient_id] AS [PATID],
        [VL].[monitor_id] AS [MONITORID],
        [VL].[collect_dt] AS [COLLECTDATE],
        [VL].[vital_value] AS [VITALS],
        [VL].[vital_time] AS [VITALSTIME],
        [MRNMAP].[organization_id] AS [ORGID],
        [MRNMAP].[mrn_xid] AS [MRN]
    FROM
        [dbo].[int_vital_live_temp] AS [VL]
        INNER JOIN [dbo].[int_mrn_map] AS [MRNMAP] ON [VL].[patient_id] = [MRNMAP].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [PM] ON [VL].[patient_id] = [PM].[patient_id]
                                                          AND [VL].[monitor_id] = [PM].[monitor_id]
    WHERE
        [VL].[patient_id] IN (SELECT
                                [PatientId]
                              FROM
                                @SelectedPatients)
        AND [merge_cd] = 'C'
        AND [VL].[collect_dt] = (SELECT
                                    MAX([collect_dt])
                                 FROM
                                    [dbo].[int_vital_live_temp] AS [VL_SUBTAB]
                                 WHERE
                                    [VL_SUBTAB].[monitor_id] = [VL].[monitor_id]
                                    AND [VL_SUBTAB].[patient_id] = [VL].[patient_id]
                                    AND [createdDT] > (GETDATE( ) - 0.002)
                                );

    --for DL patients
    SELECT
        [VitalsAll].[CodeId],
        [VitalsAll].[GdsCode] AS [Code],
        [VitalsAll].[Description] AS [Descr],
        [VitalsAll].[Units],
        [VitalsAll].[Value] AS [ResultValue],
        '' AS [ValueTypeCd],
        NULL AS [ResultStatus],
        NULL AS [Probability],
        NULL AS [ReferenceRange],
        NULL AS [AbnormalNatureCd],
        NULL AS [AbnormalCd],
        [dbo].[fnUtcDateTimeToLocalTime]([TimestampUTC]) AS [ResultTime],
        [PatientId] AS [patient_id],
        [DeviceSessions].[DeviceId]
    FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [PatientId], [GdsCode] ORDER BY [TimestampUTC] DESC) AS [RowNumber],
            [ld].[FeedTypeId],
            [ld].[TopicInstanceId],
            [ld].[Name],
            [ld].[Value],
            [GdsCode],
            [GdsCodeMap].[CodeId],
            [Units],
            [TimestampUTC],
            [PatientId],
            [DeviceSessionId],
            [Description]
         FROM
            [dbo].[LiveData] AS [ld]
            INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [ld].[TopicInstanceId]
                                                AND [TopicSessions].[EndTimeUTC] IS NULL
            INNER JOIN [dbo].[GdsCodeMap] ON [GdsCodeMap].[FeedTypeId] = [ld].[FeedTypeId]
                                             AND [GdsCodeMap].[Name] = [ld].[Name]
            INNER JOIN [dbo].[v_PatientTopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
         WHERE
            [PatientId] IN (SELECT
                                [PatientId]
                            FROM
                                @SelectedPatients)
        ) AS [VitalsAll]
        INNER JOIN [dbo].[DeviceSessions] ON [DeviceSessions].[Id] = [VitalsAll].[DeviceSessionId]
    WHERE
        [VitalsAll].[RowNumber] = 1
        AND [Units] IS NOT NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the vitals and other patient data of all the active patients to generate the Oru messages', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetLiveVitalsAndPatientDataForOru';

