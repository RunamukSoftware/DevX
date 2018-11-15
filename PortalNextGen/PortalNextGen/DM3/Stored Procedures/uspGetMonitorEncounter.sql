CREATE PROCEDURE [DM3].[uspGetMonitorEncounter]
    (
        @PatientID      INT,
        @ConnectionDateTime DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ie].[EncounterID],
            [ie].[OrganizationID],
            [ie].[ModifiedDateTime],
            [ie].[PatientID],
            [ie].[OriginalPatientID],
            [ie].[AccountID],
            [ie].[StatusCode],
            [ie].[PublicityCodeID],
            [ie].[DietTypeCodeID],
            [ie].[PatientClassCodeID],
            [ie].[ProtectionTypeCodeID],
            [ie].[VipSwitch],
            [ie].[IsolationTypeCodeID],
            [ie].[SecurityTypeCodeID],
            [ie].[PatientTypeCodeID],
            [ie].[AdmitHealthCareProviderID],
            [ie].[MedicalServiceCodeID],
            [ie].[ReferringHealthCareProviderID],
            [ie].[UnitOrganizationID],
            [ie].[AttendHealthCareProviderID],
            [ie].[PrimaryCareHealthCareProviderID],
            [ie].[FallRiskTypeCodeID],
            [ie].[BeginDateTime],
            [ie].[AmbulatoryStatusCodeID],
            [ie].[AdmitDateTime],
            [ie].[BabyCode],
            [ie].[Room],
            [ie].[RecurringCode],
            [ie].[Bed],
            [ie].[DischargeDateTime],
            [ie].[NewbornSwitch],
            [ie].[DischargeDispositionCodeID],
            [ie].[MonitorCreated],
            [ie].[Comment]
        FROM
            [Intesys].[Encounter] AS [ie]
        WHERE
            [ie].[PatientID] = @PatientID
            AND [ie].[AdmitDateTime] = @ConnectionDateTime
            AND [ie].[MonitorCreated] = 1
        ORDER BY
            [ie].[DischargeDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetMonitorEncounter';

