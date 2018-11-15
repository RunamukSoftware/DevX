CREATE PROCEDURE [HL7].[uspGetPatientVisitInformation]
    (
    @PatientID INT,
    @MonitorID [old].[utpMonitorIDTable] READONLY)
AS
BEGIN
    SET NOCOUNT ON;

    IF ((SELECT COUNT(*)FROM @MonitorID) > 0 AND @PatientID IS NOT NULL)
    BEGIN
        SELECT TOP (1)
               [enc].[PatientTypeCodeID] AS [PatientType],
               [enc].[MedicalServiceCodeID] AS [HospService],
               [enc].[PatientClassCodeID] AS [PatientClass],
               [enc].[AmbulatoryStatusCodeID] AS [AmbulatorySts],
               [enc].[VipSwitch] AS [VipIndicator],
               [enc].[DischargeDispositionCodeID] AS [DischargeDisposition],
               [enc].[AdmitDateTime],
               [enc].[DischargeDateTime],
               [encmap].[EncounterXID] AS [VisitNumber],
               [encmap].[SequenceNumber] AS [SequenceNumber],
               [monitor].[MonitorName] AS [NodeName],
               [monitor].[NodeID] AS [NodeID],
               [monitor].[Room] AS [Room],
               [monitor].[BedCode] AS [Bed],
               [organization].[OrganizationCode] AS [UnitName]
        FROM [Intesys].[Encounter] AS [enc]
            INNER JOIN [Intesys].[EncounterMap] AS [encmap]
                ON [enc].[EncounterID] = [encmap].[EncounterID]
            INNER JOIN [Intesys].[PatientMonitor] AS [patMon]
                ON [patMon].[EncounterID] = [enc].[EncounterID]
                   AND [patMon].[ActiveSwitch] = 1
            INNER JOIN [Intesys].[Monitor] AS [monitor]
                ON [patMon].[MonitorID] = [monitor].[MonitorID]
            INNER JOIN [Intesys].[Organization] AS [organization]
                ON [organization].[OrganizationID] = [monitor].[UnitOrganizationID]
        WHERE [patMon].[PatientID] = @PatientID
              AND [monitor].[MonitorID] IN (SELECT [MonitorID] FROM @MonitorID)
        UNION ALL
        SELECT DISTINCT
               CAST(NULL AS INT) AS [PatientType],
               CAST(NULL AS INT) AS [HospService],
               CAST(NULL AS INT) AS [PatientClass],
               CAST(NULL AS INT) AS [AmbulatorySts],
               CAST(NULL AS NCHAR(2)) AS [VipIndicator],
               CAST(NULL AS INT) AS [DischargeDisposition],
               [vps].[AdmitDateTime],
               [vps].[DischargedDateTime],
               CAST(NULL AS NVARCHAR(40)) AS [VisitNumber],
               CAST(NULL AS INT) AS [SequenceNumber],
               [vps].[MonitorName] AS [NodeName],
               CAST(NULL AS NVARCHAR(15)) AS [NodeID],
               [vps].[Room] AS [Room],
               [vps].[Bed] AS [Bed],
               [vps].[UnitName] AS [UnitName]
        FROM [old].[vwPatientSessions] AS [vps]
        WHERE [vps].[PatientID] = @PatientID
              AND [vps].[PatientMonitorID] IN (SELECT [MonitorID] FROM @MonitorID)
        ORDER BY [enc].[AdmitDateTime] DESC;
    END;
    ELSE
    BEGIN
        SELECT TOP (1)
               [enc].[PatientTypeCodeID] AS [PatientType],
               [enc].[MedicalServiceCodeID] AS [HospService],
               [enc].[PatientClassCodeID] AS [PatientClass],
               [enc].[AmbulatoryStatusCodeID] AS [AmbulatorySts],
               [enc].[VipSwitch] AS [VipIndicator],
               [enc].[DischargeDispositionCodeID] AS [DischargeDisposition],
               [enc].[AdmitDateTime],
               [enc].[DischargeDateTime],
               [encmap].[EncounterXID] AS [VisitNumber],
               [encmap].[SequenceNumber] AS [SequenceNumber],
               [monitor].[MonitorName] AS [NodeName],
               [monitor].[NodeID] AS [NodeID],
               [monitor].[Room] AS [Room],
               [monitor].[BedCode] AS [Bed],
               [organization].[OrganizationCode] AS [UnitName]
        FROM [Intesys].[Encounter] AS [enc]
            INNER JOIN [Intesys].[EncounterMap] AS [encmap]
                ON [enc].[EncounterID] = [encmap].[EncounterID]
            INNER JOIN [Intesys].[PatientMonitor] AS [patMon]
                ON [patMon].[EncounterID] = [enc].[EncounterID]
                   AND [patMon].[ActiveSwitch] = 1
            INNER JOIN [Intesys].[Monitor] AS [monitor]
                ON [patMon].[MonitorID] = [monitor].[MonitorID]
            INNER JOIN [Intesys].[Organization] AS [organization]
                ON [organization].[OrganizationID] = [monitor].[UnitOrganizationID]
        WHERE [patMon].[PatientID] = @PatientID
        UNION ALL
        SELECT DISTINCT
               CAST(NULL AS INT) AS [PatientType],
               CAST(NULL AS INT) AS [HospService],
               CAST(NULL AS INT) AS [PatientClass],
               CAST(NULL AS INT) AS [AmbulatorySts],
               CAST(NULL AS NCHAR(2)) AS [VipIndicator],
               CAST(NULL AS INT) AS [DischargeDisposition],
               [vps].[AdmitDateTime],
               [vps].[DischargedDateTime],
               CAST(NULL AS NVARCHAR(40)) AS [VisitNumber],
               CAST(NULL AS INT) AS [SequenceNumber],
               [vps].[MonitorName] AS [NodeName],
               CAST(NULL AS NVARCHAR(15)) AS [NodeID],
               [vps].[Room] AS [Room],
               [vps].[Bed] AS [Bed],
               [vps].[UnitName] AS [UnitName]
        FROM [old].[vwPatientSessions] AS [vps]
        WHERE [vps].[PatientID] = @PatientID
        ORDER BY [enc].[AdmitDateTime] DESC;
    END;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient visit data.  1) Query by Patient ID  2) Query by Patient ID and Monitor ID', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientVisitInformation';

