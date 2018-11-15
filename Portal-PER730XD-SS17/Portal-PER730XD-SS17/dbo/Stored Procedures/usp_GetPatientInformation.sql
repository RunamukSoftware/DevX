CREATE PROCEDURE [dbo].[usp_GetPatientInformation]
    (@deviceIds [dbo].[GetPatientUpdateInformationType] READONLY)
AS
BEGIN

    SET NOCOUNT ON;

    /*
        This gives the currently known PatientSession - Device association for all ACTIVE devices
    */
    WITH [PatientSessionActiveDevice] ( [PatientSessionId], [DeviceId], [MonitoringStatus] ) AS
    (
        SELECT [PatientData].[PatientSessionId],
               [DeviceSessions].[DeviceId],
               [MonitoringStatusSequence].[MonitoringStatus]
            FROM [dbo].[PatientData]
            INNER JOIN
            (
                SELECT [PatientSessionId], MAX([TimestampUTC]) AS [MaxTimestampUTC]
                    FROM [dbo].[PatientData]
                    GROUP BY [PatientSessionId]
            ) AS [PatientSessionMaxTimestampUTC]
                ON [PatientData].[PatientSessionId] = [PatientSessionMaxTimestampUTC].[PatientSessionId]
                AND [PatientData].[TimestampUTC] = [PatientSessionMaxTimestampUTC].[MaxTimestampUTC]
            INNER JOIN [dbo].[DeviceSessions]
                ON [DeviceSessions].[Id]=[PatientData].[DeviceSessionId]
                AND [DeviceSessions].[EndTimeUTC] IS NULL
            LEFT OUTER JOIN
            (
                SELECT [DeviceSessionId],
                       [Value] AS [MonitoringStatus],
                       ROW_NUMBER() OVER (PARTITION BY [DeviceSessionId], [Name] ORDER BY [TimestampUTC] DESC) AS [RowNumber]
                    FROM [dbo].[DeviceInfoData] AS [DeviceInfoSequence]
                    WHERE [Name] = N'MonitoringStatus'

            ) AS [MonitoringStatusSequence]
                ON [MonitoringStatusSequence].[DeviceSessionId]=[DeviceSessions].[Id]
                AND [MonitoringStatusSequence].[RowNumber]=1
    )
    SELECT DISTINCT
           [Ids].[PatientSessionId]
          ,[Ids].[DeviceId]
          ,[ID1] =
            CASE
                WHEN (
                    [v_DevicePatientIdActive].[DeviceId] IS NULL
                OR  [Ids].[PatientSessionId] = [psad].[PatientSessionId]
                OR  [psad].[MonitoringStatus] = N'Standby'
                )
                AND (
                   [int_patient_monitor].[monitor_id] IS NULL
                OR [int_monitor].[standby] IS NOT NULL
                )
                    THEN [mrn_xid]
                ELSE [dbo].[fnMarkIdAsDuplicate]([mrn_xid])
            END
          ,[ID2] = [mrn_xid2]
          ,[FirstName] = [first_nm]
          ,[MiddleName] = [middle_nm]
          ,[LastName] = [last_nm]
          ,[Gender] =
            CASE [gender_code].[code]
                WHEN 'M' THEN 'Male'
                WHEN 'F' THEN 'Female'
                ELSE NULL
            END
          ,[DOB] = CONVERT(VARCHAR, [dob], 126)
          ,[BSA] = CAST([bsa] AS VARCHAR)

        FROM @deviceIds AS [Ids]
        --
        -- The demographics currently recorded for the ID1
        --
        INNER JOIN [dbo].[int_mrn_map] ON [int_mrn_map].[mrn_xid]=[Ids].[ID1] AND [int_mrn_map].[merge_cd]='C'
        LEFT OUTER JOIN [dbo].[int_patient] ON [int_patient].[patient_id]=[int_mrn_map].[patient_id]
        LEFT OUTER JOIN [dbo].[int_person] ON [int_person].[person_id]=[int_mrn_map].[patient_id]
        LEFT OUTER JOIN [dbo].[int_misc_code] AS [gender_code] ON [gender_code].[code_id]=[int_patient].[gender_cid]
        --
        -- The Dataloader devices that are active on the same ID1 (and different from the current device)
        -- For each of these also look up the current PatientSessionId so that discovering a different device
        -- with the same patient session (edit ET channel for example) doesn't yield a duplicate.
        --
        LEFT OUTER JOIN [dbo].[v_DevicePatientIdActive]
            ON [v_DevicePatientIdActive].[DeviceId] <> [Ids].[DeviceId]
            AND [v_DevicePatientIdActive].[ID1] = [Ids].[ID1]
        LEFT OUTER JOIN [PatientSessionActiveDevice] AS [psad]
            ON [psad].[DeviceId] = [v_DevicePatientIdActive].[DeviceId]
        --
        -- The Legacy devices that are active on the same ID1
        --
        LEFT OUTER JOIN [dbo].[int_patient_monitor]
            ON [int_patient_monitor].[patient_id] = [int_mrn_map].[patient_id]
            AND [int_patient_monitor].[active_sw]='1'
        LEFT OUTER JOIN [dbo].[int_monitor]
            ON [int_monitor].[monitor_id]=[int_patient_monitor].[monitor_id]
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get basic patient information for a list of devices.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetPatientInformation';

