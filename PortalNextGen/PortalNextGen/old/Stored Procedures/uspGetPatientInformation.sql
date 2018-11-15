CREATE PROCEDURE [old].[uspGetPatientInformation] (@DeviceIDs [old].[utpPatientUpdateInformation] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        --
        -- This gives the currently known PatientSession - Device association for all ACTIVE devices
        --
        WITH [PatientSessionActiveDevice] ([PatientSessionID], [DeviceID], [MonitoringStatus])
        AS (   SELECT
                       [pd].[PatientSessionID],
                       [ds].[DeviceID],
                       [MonitoringStatusSequence].[MonitoringStatus]
               FROM
                       [old].[Patient]       AS [pd]
                   INNER JOIN
                       (
                           SELECT
                               [pd2].[PatientSessionID],
                               MAX([pd2].[Timestamp]) AS [MaxTimestamp]
                           FROM
                               [old].[Patient] AS [pd2]
                           GROUP BY
                               [pd2].[PatientSessionID]
                       )                     AS [PatientSessionMaxTimestamp]
                           ON [pd].[PatientSessionID] = [PatientSessionMaxTimestamp].[PatientSessionID]
                              AND [pd].[Timestamp] = [PatientSessionMaxTimestamp].[MaxTimestamp]
                   INNER JOIN
                       [old].[DeviceSession] AS [ds]
                           ON [ds].[DeviceSessionID] = [pd].[DeviceSessionID]
                              AND [ds].[EndDateTime] IS NULL
                   LEFT OUTER JOIN
                       (
                           SELECT
                               [DeviceInfoSequence].[DeviceSessionID],
                               [DeviceInfoSequence].[Value] AS [MonitoringStatus],
                               ROW_NUMBER() OVER (PARTITION BY
                                                      [DeviceInfoSequence].[DeviceSessionID],
                                                      [DeviceInfoSequence].[Name]
                                                  ORDER BY
                                                      [DeviceInfoSequence].[DateTimeStamp] DESC
                                                 )          AS [RowNumber]
                           FROM
                               [old].[DeviceInformation] AS [DeviceInfoSequence]
                           WHERE
                               [DeviceInfoSequence].[Name] = N'MonitoringStatus'
                       )                     AS [MonitoringStatusSequence]
                           ON [MonitoringStatusSequence].[DeviceSessionID] = [ds].[DeviceSessionID]
                              AND [MonitoringStatusSequence].[RowNumber] = 1)
        SELECT DISTINCT
                [IDs].[DeviceID],
                CASE
                    WHEN (
                             [vdpia].[DeviceID] IS NULL
                             OR [IDs].[PatientSessionID] = [psad].[PatientSessionID]
                             OR [psad].[MonitoringStatus] = N'Standby'
                         )
                         AND
                             (
                                 [ipm].[MonitorID] IS NULL
                                 OR [im].[Standby] IS NOT NULL
                             )
                        THEN [imm].[MedicalRecordNumberXID]
                    ELSE
                        [old].[ufnMarkIdAsDuplicate]([imm].[MedicalRecordNumberXID])
                END                                            AS [ID1],
                [imm].[MedicalRecordNumberXID2]                AS [ID2],
                [ipe].[FirstName]                              AS [FirstName],
                [ipe].[MiddleName]                             AS [MiddleName],
                [ipe].[LastName]                               AS [LastName],
                CASE [gender_code].[Code]
                    WHEN N'M'
                        THEN 'Male'
                    WHEN N'F'
                        THEN 'Female'
                    ELSE
                        NULL
                END                                            AS [Gender],
                CONVERT(VARCHAR(30), [ipa].[DateOfBirth], 126) AS [DateOfBirth],
                [ipa].[BodySurfaceArea]
        FROM
                @DeviceIDs                         AS [IDs]
            --
            -- The demographics currently recorded for the ID1
            --
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [imm].[MedicalRecordNumberXID] = [IDs].[ID1]
                       AND [imm].[MergeCode] = 'C'
            LEFT OUTER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [imm].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode]      AS [gender_code]
                    ON [gender_code].[CodeID] = [ipa].[GenderCodeID]
            --
            -- The Dataloader devices that are active on the same ID1 (and different from the current device)
            -- For each of these also look up the current PatientSessionID so that discovering a different device
            -- with the same patient session (edit Enhanced Telemetry (ET) channel for example) doesn't yield a duplicate.
            --
            LEFT OUTER JOIN
                [old].[vwDevicePatientIdActive]    AS [vdpia]
                    ON [vdpia].[DeviceID] <> [IDs].[DeviceID]
                       AND [vdpia].[ID1] = [IDs].[ID1]
            LEFT OUTER JOIN
                [PatientSessionActiveDevice]       AS [psad]
                    ON [psad].[DeviceID] = [vdpia].[DeviceID]
            --
            -- The Legacy devices that are active on the same ID1
            --
            LEFT OUTER JOIN
                [Intesys].[PatientMonitor]         AS [ipm]
                    ON [ipm].[PatientID] = [imm].[PatientID]
                       AND [ipm].[ActiveSwitch] = 1
            LEFT OUTER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [im].[MonitorID] = [ipm].[MonitorID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get basic patient information for a list of devices.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientInformation';

