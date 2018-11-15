CREATE PROCEDURE [old].[uspLoaderPatientPolling]
    (
        @OrganizationID INT,
        @NetworkID      NVARCHAR(50)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [MM].[MedicalRecordNumberXID],
            [MM].[MedicalRecordNumberXID2],
            [PAT].[PatientID],
            [PAT].[DateOfBirth],
            [PAT].[GenderCodeID],
            [PAT].[Height],
            [PAT].[Weight],
            [PAT].[BodySurfaceArea],
            [PER].[LastName],
            [PER].[FirstName],
            [PER].[MiddleName],
            [PM].[PatientMonitorID],
            [PM].[MonitorInterval],
            [PM].[MonitorConnectDateTime],
            [PM].[LastPollingDateTime],
            [PM].[LastResultDateTime],
            [PM].[LastEpisodicDateTime],
            [PM].[PollStartDateTime],
            [PM].[PollEndDateTime],
            [PM].[MonitorStatus],
            [PM].[MonitorError],
            [PM].[EncounterID],
            [PM].[LiveUntilDateTime],
            [MON].[NetworkID],
            [MON].[MonitorID],
            [MON].[MonitorName],
            [MON].[NodeID],
            [MON].[BedID],
            [MON].[Room],
            [MON].[MonitorTypeCode],
            [MON].[UnitOrganizationID],
            [ORG].[OutboundInterval],
            [ORG].[OrganizationCode]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [MM]
            INNER JOIN
                [Intesys].[Patient]            AS [PAT]
                    ON [MM].[PatientID] = [PAT].[PatientID]
            INNER JOIN
                [Intesys].[Person]             AS [PER]
                    ON [PAT].[PatientID] = [PER].[PersonID]
            INNER JOIN
                [Intesys].[PatientMonitor]     AS [PM]
                    ON [PAT].[PatientID] = [PM].[PatientID]
            INNER JOIN
                [Intesys].[Monitor]            AS [MON]
                    ON [PM].[MonitorID] = [MON].[MonitorID]
            INNER JOIN
                [Intesys].[Encounter]          AS [ENC]
                    ON [PM].[EncounterID] = [ENC].[EncounterID]
            INNER JOIN
                [Intesys].[Organization]       AS [ORG]
                    ON [MON].[UnitOrganizationID] = [ORG].[OrganizationID]
        WHERE
            [MM].[MergeCode] = 'C'
            AND [ENC].[DischargeDateTime] IS NULL
            AND [MM].[OrganizationID] = @OrganizationID
            AND [MON].[NetworkID] = @NetworkID
            AND [PM].[ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspLoaderPatientPolling';

