CREATE PROCEDURE [old].[uspGetPatientData] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                [ipe].[FirstName],
                [ipe].[LastName],
                [im].[MonitorName],
                [imm].[MedicalRecordNumberXID2] AS [AccountID],
                [imm].[MedicalRecordNumberXID]  AS [MedicalRecordNumberID],
                [im].[UnitOrganizationID]       AS [UnitID],
                [CHILD].[OrganizationCode]      AS [UnitNAME],
                [PARENT].[OrganizationID]       AS [FacilityID],
                [PARENT].[OrganizationName]     AS [FacilityName],
                [ipa].[DateOfBirth],
                [ie].[AdmitDateTime],
                [ie].[DischargeDateTime],
                [ipm].[PatientMonitorID],
                CASE
                    WHEN [ie].[DischargeDateTime] IS NULL
                         AND ISNULL([im].[Standby], 0) <> 1
                        THEN 'A' -- active
                    WHEN [ie].[DischargeDateTime] IS NULL
                         AND ISNULL([im].[Standby], 0) = 1
                        THEN 'S' -- standby
                    ELSE
                        'D'      -- discharged
                END                             AS [Status],
                [ipm].[LastResultDateTime]      AS [Precedence]
        FROM
                [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [Intesys].[Patient]                AS [ipa]
                    ON [ipa].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Encounter]              AS [ie]
                    ON [ie].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [ipm]
                    ON [ie].[EncounterID] = [ipm].[EncounterID]
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [ipm].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[Organization]           AS [CHILD]
                    ON [im].[UnitOrganizationID] = [CHILD].[OrganizationID]
            LEFT OUTER JOIN
                [Intesys].[Organization]           AS [PARENT]
                    ON [PARENT].[OrganizationID] = [CHILD].[ParentOrganizationID]
        WHERE
                [imm].[PatientID] = @PatientID
                AND [imm].[MergeCode] = 'C'
        UNION
        SELECT
            [vps].[FirstName],
            [vps].[LastName],
            [vps].[MonitorName],
            [vps].[AccountID],
            [vps].[MedicalRecordNumberID],
            [vps].[UnitID],
            [vps].[UnitName],
            [vps].[FacilityID],
            [vps].[FacilityName],
            [vps].[DateOfBirth],
            [vps].[AdmitDateTime]                            AS [AdmitTime],
            [vps].[DischargedDateTime]                       AS [DischargedTime],
            [vps].[PatientMonitorID],
            [vps].[Status],
            ISNULL([vps].[DischargedDateTime], GETUTCDATE()) AS [Precedence]
        FROM
            [old].[vwPatientSessions] AS [vps]
        WHERE
            [vps].[PatientID] = @PatientID
        ORDER BY
            [Status] ASC,
            [Precedence] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientData';

