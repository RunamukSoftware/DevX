CREATE PROCEDURE [old].[uspGetPatientByExternalIDAndDevice]
    (
        @MedicalRecordNumberID      NVARCHAR(30),
        @Device                     NVARCHAR(30),
        @LoginName                  NVARCHAR(64),
        @IsVipSearchable            BIT,
        @IsRestrictedUnitSearchable BIT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                [imm].[PatientID],
                [ipe].[FirstName],
                [ipe].[LastName],
                [im].[MonitorName],
                [imm].[MedicalRecordNumberXID2] AS [AccountID],
                [imm].[MedicalRecordNumberXID]  AS [MedicalRecordNumberID],
                [ORG1].[OrganizationID]         AS [UnitID],
                [ORG1].[OrganizationCode]       AS [UnitName],
                [ORG2].[OrganizationID]         AS [FacilityID],
                [ORG2].[OrganizationName]       AS [FacilityNAME],
                [ipa].[DateOfBirth],
                [ie].[AdmitDateTime],
                [ie].[DischargeDateTime],
                [ipm].[PatientMonitorID],
                CASE
                    WHEN [ie].[DischargeDateTime] IS NULL
                        THEN 'A'
                    ELSE
                        'D'
                END                             AS [Status]
        FROM
                [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [ipm]
                    ON [ipm].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Encounter]              AS [ie]
                    ON [ie].[EncounterID] = [ipm].[EncounterID]
                       AND
                           (
                               @IsVipSearchable = 1
                               OR [ie].[VipSwitch] IS NULL
                           )
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [im].[MonitorID] = [ipm].[MonitorID]
                       AND
                           (
                               @Device IS NULL
                               OR [im].[NodeID] = @Device
                           )
            LEFT OUTER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [imm].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Organization]           AS [ORG1]
                    ON ([im].[UnitOrganizationID] = [ORG1].[OrganizationID])
                       AND
                           (
                               @IsRestrictedUnitSearchable = 1
                               OR [ORG1].[OrganizationID] NOT IN (
                                                                     SELECT
                                                                         [cro].[OrganizationID]
                                                                     FROM
                                                                         [CDR].[RestrictedOrganization] AS [cro]
                                                                     WHERE
                                                                         [cro].[RoleID] =
                                                                         (
                                                                             SELECT
                                                                                 [iu].[RoleID]
                                                                             FROM
                                                                                 [User].[User] AS [iu]
                                                                             WHERE
                                                                                 [iu].[LoginName] = @LoginName
                                                                         )
                                                                 )
                           )
            LEFT OUTER JOIN
                [Intesys].[Organization]           AS [ORG2]
                    ON [ORG2].[OrganizationID] = [ORG1].[ParentOrganizationID]
        WHERE
                [imm].[MedicalRecordNumberXID] = @MedicalRecordNumberID
                AND [imm].[MergeCode] = 'C'
        UNION ALL
        SELECT
                [imm].[PatientID],
                [ipe].[FirstName],
                [ipe].[LastName],
                CASE
                    WHEN [Assignment].[BedName] IS NULL
                         OR [Assignment].[MonitorName] IS NULL
                        THEN [d].[Name]
                    ELSE
                        RTRIM([Assignment].[BedName]) + '(' + RTRIM([Assignment].[Channel]) + ')'
                END                             AS [MonitorName],
                [imm].[MedicalRecordNumberXID2] AS [AccountID],
                [imm].[MedicalRecordNumberXID]  AS [MedicalRecordNumberID],
                [Units].[OrganizationID]        AS [UnitID],
                [Units].[OrganizationName]      AS [UnitName],
                [Facilities].[OrganizationID]   AS [FacilityID],
                [Facilities].[OrganizationName] AS [FacilityName],
                [ipa].[DateOfBirth],
                [ps].[BeginDateTime]            AS [AdmitTimeC],
                [ps].[EndDateTime]              AS [DischargedTime],
                [ps].[PatientSessionID]         AS [PatientMonitorID],
                CASE
                    WHEN [ps].[EndDateTime] IS NULL
                        THEN 'A'
                    ELSE
                        'D'
                END                             AS [Status]
        FROM
                [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [old].[PatientSessionMap]          AS [psm]
                    ON [psm].[PatientID] = [imm].[PatientID]
            INNER JOIN
                (
                    SELECT
                        [psm2].[PatientSessionID],
                        MAX([psm2].[PatientSessionMapID]) AS [MaxSeq]
                    FROM
                        [old].[PatientSessionMap] AS [psm2]
                    GROUP BY
                        [psm2].[PatientSessionID]
                )                                  AS [PatientSessionMaxSeq]
                    ON [PatientSessionMaxSeq].[PatientSessionID] = [psm].[PatientSessionID]
                       AND [PatientSessionMaxSeq].[MaxSeq] = [psm].[PatientSessionMapID]
            INNER JOIN
                [old].[PatientSession]             AS [ps]
                    ON [ps].[PatientSessionID] = [psm].[PatientSessionID]
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
                                                  ) AS [r]
                            FROM
                                [old].[Patient] AS [pd]
                        ) AS [PatientSessionsDeviceSequence]
                    WHERE
                        [PatientSessionsDeviceSequence].[r] = 1
                )                                  AS [LatestPatientSessionDevice]
                    ON [LatestPatientSessionDevice].[PatientSessionID] = [ps].[PatientSessionID]
            INNER JOIN
                [old].[DeviceSession]              AS [ds2]
                    ON [ds2].[DeviceSessionID] = [LatestPatientSessionDevice].[DeviceSessionID]
            INNER JOIN
                [old].[Device]                     AS [d]
                    ON [ds2].[DeviceID] = [d].[DeviceID]
                       AND
                           (
                               @Device IS NULL
                               OR [d].[Name] = @Device
                           )
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
                       AND
                           (
                               @IsRestrictedUnitSearchable = 1
                               OR [Units].[OrganizationID] NOT IN (
                                                                      SELECT
                                                                          [cro].[OrganizationID]
                                                                      FROM
                                                                          [CDR].[RestrictedOrganization] AS [cro]
                                                                      WHERE
                                                                          [cro].[RoleID] =
                                                                          (
                                                                              SELECT
                                                                                  [iu].[RoleID]
                                                                              FROM
                                                                                  [User].[User] AS [iu]
                                                                              WHERE
                                                                                  [iu].[LoginName] = @LoginName
                                                                          )
                                                                  )
                           )
            LEFT OUTER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            LEFT OUTER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [imm].[PatientID]
        WHERE
                [imm].[MedicalRecordNumberXID] = @MedicalRecordNumberID
                AND [imm].[MergeCode] = 'C'
        ORDER BY
            [ie].[AdmitDateTime] DESC,
            [Status],
            [ipe].[LastName],
            [ipe].[FirstName],
            [im].[MonitorName];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient information by the external medical record ID and device name.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientByExternalIDAndDevice';

