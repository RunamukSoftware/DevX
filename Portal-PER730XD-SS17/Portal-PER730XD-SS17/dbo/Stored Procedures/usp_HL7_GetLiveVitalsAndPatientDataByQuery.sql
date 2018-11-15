CREATE PROCEDURE [dbo].[usp_HL7_GetLiveVitalsAndPatientDataByQuery]
    (
     @QRYItem NVARCHAR(80),
     @type INT = -1
    )
AS
BEGIN
    DECLARE @patient_id UNIQUEIDENTIFIER;

    SET @patient_id = [dbo].[fn_HL7_GetPatientIdFromQueryItemType](@QRYItem, @type);

    --Person and Patient data for PID
    SELECT DISTINCT
        [Pat].[dob] AS [DateOfBirth],
        [Pat].[gender_cid] AS [GenderCd],
        [Pat].[death_dt] AS [DeathDate],
        [person].[first_nm] AS [FirstName],
        [person].[middle_nm] AS [MiddleName],
        [person].[last_nm] AS [LastName],
        [int_mrn_map].[mrn_xid2] AS [AccountNumber],
        [int_mrn_map].[mrn_xid] AS [MRN],
        [int_mrn_map].[patient_id] AS [patient_id],
        [int_patient_monitor].[monitor_id] AS [DeviceId]
    FROM
        [dbo].[int_patient] AS [Pat]
        INNER JOIN [dbo].[int_person] AS [person] ON [Pat].[patient_id] = [person].[person_id]
                                                     AND [Pat].[patient_id] = @patient_id
        INNER JOIN [dbo].[int_mrn_map] ON [Pat].[patient_id] = [int_mrn_map].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] ON [Pat].[patient_id] = [int_patient_monitor].[patient_id]
    WHERE
        [int_mrn_map].[merge_cd] = 'C'
    UNION ALL
    SELECT
        NULL AS [DateOfBirth],
        NULL AS [GenderCd],
        NULL AS [DeathDate],
        [FIRST_NAME] AS [FirstName],
        [MIDDLE_NAME] AS [MiddleName],
        [LAST_NAME] AS [LastName],
        [ACCOUNT_ID] AS [AccountNumber],
        [MRN_ID] AS [MRN],
        [v_PatientSessions].[patient_id],
        [DeviceId]
    FROM
        [dbo].[v_PatientSessions]
    WHERE
        [patient_id] = @patient_id
        AND [v_PatientSessions].[STATUS] = 'A'; -- Per Alex Beechie - Bug # 10012

    --Get Order data
    SELECT TOP 1
        [OrderNumber].[Value] AS [ORDER_ID],
        [send_app] AS [SENDING_APPLICATION],
        CAST([OrderStatus].[Value] AS INT) AS [ORDER_STATUS],
        CAST(NULL AS DATETIME) AS [ORDER_DATE_TIME],
        @patient_id AS [patient_id]
    FROM
        [dbo].[int_gateway]
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

    -- Get OBR
    SELECT DISTINCT
        [OrderNumber].[Value] AS [ORDER_ID],
        [send_app] AS [SENDING_APPLICATION],
        CAST(NULL AS DATETIME) AS [ORDER_DATE_TIME]
    FROM
        [dbo].[int_gateway]
        CROSS JOIN (SELECT
                        [Value]
                    FROM
                        [dbo].[ApplicationSettings]
                    WHERE
                        [Key] = 'DefaultFillerOrderNumber'
                   ) AS [OrderNumber];

    --Patient visit/encounter information
    SELECT
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
        [patMon].[monitor_id] AS [DeviceId]
    FROM
        [dbo].[int_encounter] AS [enc]
        INNER JOIN [dbo].[int_encounter_map] AS [encmap] ON [enc].[encounter_id] = [encmap].[encounter_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [patMon] ON [patMon].[encounter_id] = [enc].[encounter_id]
                                                              AND [patMon].[active_sw] = 1
        INNER JOIN [dbo].[int_monitor] AS [monitor] ON [patMon].[monitor_id] = [monitor].[monitor_id]
        INNER JOIN [dbo].[int_organization] AS [organization] ON [organization].[organization_id] = [monitor].[unit_org_id]
    WHERE
        [patMon].[patient_id] = @patient_id
        AND [enc].[discharge_dt] IS NULL
    UNION ALL
    SELECT DISTINCT
        CAST(NULL AS INT) AS [PatientType],
        CAST(NULL AS INT) AS [HospService],
        CAST(NULL AS INT) AS [PatientClass],
        CAST(NULL AS INT) AS [AmbulatorySts],
        CAST(NULL AS NCHAR(2)) AS [VipIndic],
        CAST(NULL AS INT) AS [DischDisposition],
        [dbo].[fnUtcDateTimeToLocalTime]([v_PatientSessions].[ADMIT_TIME_UTC]) AS [AdmitDate],
        [dbo].[fnUtcDateTimeToLocalTime]([v_PatientSessions].[DISCHARGED_TIME_UTC]) AS [DischargeDt],
        CAST(NULL AS NVARCHAR(40)) AS [VisitNumber],
        [v_PatientSessions].[patient_id] AS [patient_id],
        CAST(NULL AS INT) AS [SeqNo],
        [v_PatientSessions].[MONITOR_NAME] AS [NodeName],
        CAST(NULL AS NVARCHAR(15)) AS [NodeId],
        [v_PatientSessions].[ROOM] AS [Room],
        [v_PatientSessions].[BED] AS [Bed],
        [v_PatientSessions].[UNIT_NAME] AS [UnitName],
        [v_PatientSessions].[DeviceId] AS [DeviceId]
    FROM
        [dbo].[v_PatientSessions]
    WHERE
        [patient_id] = @patient_id
        AND [v_PatientSessions].[DISCHARGED_TIME_UTC] IS NULL -- Per Alex Beechie - Bug # 10012
    ORDER BY
        [AdmitDate] DESC;

    --Get vitals

    -- For ML patients (Legacy Tele)
    SELECT DISTINCT
        [vl].[patient_id] AS [PATID],
        [vl].[monitor_id] AS [MONITORID],
        [vl].[collect_dt] AS [COLLECTDATE],
        [vl].[vital_value] AS [VITALS],
        [vl].[vital_time] AS [VITALSTIME],
        [imm].[organization_id] AS [ORGID],
        [imm].[mrn_xid] AS [MRN]
    FROM
        [dbo].[int_vital_live_temp] AS [vl]
        INNER JOIN [dbo].[int_mrn_map] AS [imm] ON [vl].[patient_id] = [imm].[patient_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [pm] ON [vl].[patient_id] = [pm].[patient_id]
                                                          AND [vl].[monitor_id] = [pm].[monitor_id]
    WHERE
        [vl].[patient_id] = @patient_id
        AND [merge_cd] = 'C'
        AND [vl].[createdDT] = (SELECT
                                    MAX([createdDT])
                                FROM
                                    [dbo].[int_vital_live_temp] AS [VL_SUBTAB]
                                WHERE
                                    [VL_SUBTAB].[monitor_id] = [vl].[monitor_id]
                                    AND [VL_SUBTAB].[patient_id] = [vl].[patient_id]
                                    AND [createdDT] > (GETDATE( ) - 0.002)
                               )
    ORDER BY
        [vl].[patient_id];

    -- For DL patients
    SELECT
        [VitalsAll].[CodeId],
        [VitalsAll].[GdsCode] AS [Code],
        [VitalsAll].[Description] AS [Descr],
        [VitalsAll].[Units],
        [VitalsAll].[Value] AS [ResultValue],
        N'' AS [ValueTypeCd],
        NULL AS [ResultStatus],
        NULL AS [Probability],
        NULL AS [ReferenceRange],
        NULL AS [AbnormalNatureCd],
        NULL AS [AbnormalCd],
        [dbo].[fnUtcDateTimeToLocalTime]([TimestampUTC]) AS [ResultTime],
        [PatientId] AS [patient_id]
    FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [PatientId], [GdsCode] ORDER BY [TimestampUTC] DESC) AS [RowNumber],
            [ld].[FeedTypeId],
            [ld].[TopicInstanceId],
            [ld].[Name],
            [ld].[Value],
            [GdsCode],
            [gcm].[CodeId],
            [Units],
            [TimestampUTC],
            [PatientId],
            [Description]
         FROM
            [dbo].[LiveData] AS [ld]
            INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[TopicInstanceId] = [ld].[TopicInstanceId]
                                                AND [TopicSessions].[EndTimeUTC] IS NULL
            INNER JOIN [dbo].[GdsCodeMap] AS [gcm] ON [gcm].[FeedTypeId] = [ld].[FeedTypeId]
                                                      AND [gcm].[Name] = [ld].[Name]
            INNER JOIN [dbo].[v_PatientTopicSessions] ON [TopicSessions].[Id] = [v_PatientTopicSessions].[TopicSessionId]
         WHERE
            [PatientId] = @patient_id
        ) AS [VitalsAll]
    WHERE
        [VitalsAll].[RowNumber] = 1
        AND [Units] IS NOT NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the vitals and other patient data of all the active patients to generate the Oru messages', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetLiveVitalsAndPatientDataByQuery';

