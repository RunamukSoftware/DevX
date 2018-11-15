CREATE PROCEDURE [HL7].[uspGetLiveVitalsAndPatientDataForOru]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastRunDateTime DATETIME2(7);

    -- Create the equivalent date time to (GETDATE( ) - 0.002)
    DECLARE @LowerTimeLimit DATETIME2(7) = DATEADD(MILLISECOND, -172800, SYSUTCDATETIME());

    CREATE TABLE [#SelectedPatients] ([PatientID] INT);

    SELECT @LastRunDateTime = DATEADD(SECOND, -CAST([icv].[KeyValue] AS INT), SYSUTCDATETIME())
    FROM [Intesys].[ConfigurationValue] AS [icv]
    WHERE [icv].[KeyName] = 'VitalsRefreshInterval';

    --Get all active patient Ids and their corresponding Monitor Ids
    INSERT INTO [#SelectedPatients] ([PatientID])
    (SELECT [MAP].[PatientID] AS [PatientID]
     FROM [Intesys].[MedicalRecordNumberMap] AS [MAP]
         INNER JOIN [Intesys].[PatientMonitor] AS [PATMON]
             ON [PATMON].[PatientID] = [MAP].[PatientID]
         INNER JOIN [Intesys].[Monitor] AS [MONITOR]
             ON [MONITOR].[MonitorID] = [PATMON].[MonitorID]
         INNER JOIN [Intesys].[ProductAccess] AS [ACCESS]
             ON [ACCESS].[OrganizationID] = [MONITOR].[UnitOrganizationID]
         INNER JOIN [Intesys].[Organization] AS [ORG]
             ON [ORG].[OrganizationID] = [MONITOR].[UnitOrganizationID]
                AND [ORG].[OutboundInterval] > 0
         INNER JOIN [Intesys].[Encounter] AS [ENC]
             ON [PATMON].[EncounterID] = [ENC].[EncounterID]
     WHERE [MAP].[MergeCode] = 'C'
           AND [ACCESS].[ProductCode] = 'outHL7'
           AND [ORG].[CategoryCode] = 'D'
           AND ([ENC].[DischargeDateTime] IS NULL
                OR [ENC].[ModifiedDateTime] > @LastRunDateTime)
     UNION
     SELECT [DLPAT].[PatientID] AS [PatientID]
     FROM [old].[vwPatientSessions] AS [DLPAT]
         INNER JOIN [Intesys].[ProductAccess] AS [Access]
             ON [Access].[OrganizationID] = [DLPAT].[UnitID]
         INNER JOIN [Intesys].[Organization] AS [ORG]
             ON [ORG].[OrganizationID] = [DLPAT].[UnitID]
                AND [ORG].[OutboundInterval] > 0
     WHERE [DLPAT].[Status] = 'A'
           AND [Access].[ProductCode] = 'outHL7'
           AND [ORG].[CategoryCode] = 'D');

    --Person and Patient data for PID
    DECLARE @FilterUV BIT;
    SELECT @FilterUV = CASE [icv].[KeyValue]
                           WHEN 'true'
                               THEN 1
                           ELSE
                               0
                       END
    FROM [Intesys].[ConfigurationValue] AS [icv]
    WHERE [icv].[KeyName] = 'DoNotSendUV';

    SELECT
        [Pat].[DateOfBirth] AS [DateOfBirth],
        [Pat].[GenderCodeID] AS [GenderCode],
        [Pat].[DeathDate] AS [DeathDate],
        [person].[FirstName] AS [FirstName],
        [person].[MiddleName] AS [MiddleName],
        [person].[LastName] AS [LastName],
        [imm].[MedicalRecordNumberXID2] AS [AccountNumber],
        [imm].[MedicalRecordNumberXID] AS [MedicalRecordNumber],
        [imm].[PatientID] AS [PatientID]
    FROM [Intesys].[Patient] AS [Pat]
        INNER JOIN [Intesys].[Person] AS [person]
            ON [Pat].[PatientID] = [person].[PersonID]
               AND [Pat].[PatientID] IN (SELECT [PatientID] FROM [#SelectedPatients])
        INNER JOIN [Intesys].[MedicalRecordNumberMap] AS [imm]
            ON [Pat].[PatientID] = [imm].[PatientID]
    WHERE ([imm].[MergeCode] = 'C')
          AND ((@FilterUV = 1
                AND [imm].[MedicalRecordNumberXID] NOT LIKE N'Uvw%')
               OR (@FilterUV = 0));

    --Get Order data
    SELECT
        [OrderNumber].[Value] AS [OrderID],
        [SendingApplication].[SendingApplication] AS [SendingApplication],
        CAST([OrderStatus].[Value] AS INT) AS [OrderStatus],
        CAST(NULL AS DATETIME2(7)) AS [OrderDateTime],
        [Patients].[PatientID]
    FROM (SELECT [PatientID] FROM [#SelectedPatients]) AS [Patients]
        CROSS JOIN (SELECT TOP (1)
                           [ig].[SendingApplication]
                    FROM [Intesys].[Gateway] AS [ig]) AS [SendingApplication]
        CROSS JOIN (SELECT [as].[Value]
                    FROM [old].[ApplicationSetting] AS [as]
                    WHERE [as].[Key] = 'DefaultFillerOrderStatus') AS [OrderStatus]
        CROSS JOIN (SELECT [as2].[Value]
                    FROM [old].[ApplicationSetting] AS [as2]
                    WHERE [as2].[Key] = 'DefaultFillerOrderNumber') AS [OrderNumber];

    --Patient visit/encounter information
    SELECT DISTINCT
           [enc].[PatientTypeCodeID] AS [PatientType],
           [enc].[MedicalServiceCodeID] AS [HospService],
           [enc].[PatientClassCodeID] AS [PatientClass],
           [enc].[AmbulatoryStatusCodeID] AS [AmbulatorySts],
           [enc].[VipSwitch] AS [VipIndicator],
           [enc].[DischargeDispositionCodeID] AS [DischargeDisposition],
           [enc].[AdmitDateTime] AS [AdmitDate],
           [enc].[DischargeDateTime] AS [DischargeDateTime],
           [encmap].[EncounterXID] AS [VisitNumber],
           [enc].[PatientID] AS [PatientID],
           [encmap].[SequenceNumber] AS [SequenceNumber],
           [monitor].[MonitorName] AS [NodeName],
           [monitor].[NodeID] AS [NodeID],
           [monitor].[Room] AS [Room],
           [monitor].[BedCode] AS [Bed],
           [organization].[OrganizationCode] AS [UnitName],
           [monitor].[MonitorID] AS [DeviceID]
    FROM [Intesys].[Encounter] AS [enc]
        INNER JOIN [Intesys].[EncounterMap] AS [encmap]
            ON [enc].[EncounterID] = [encmap].[EncounterID]
        INNER JOIN [Intesys].[PatientMonitor] AS [patMon]
            ON [patMon].[EncounterID] = [enc].[EncounterID]
               AND ([patMon].[ActiveSwitch] = 1
                    OR [enc].[ModifiedDateTime] > @LastRunDateTime)
        INNER JOIN [Intesys].[Monitor] AS [monitor]
            ON [patMon].[MonitorID] = [monitor].[MonitorID]
        INNER JOIN [Intesys].[Organization] AS [organization]
            ON [organization].[OrganizationID] = [monitor].[UnitOrganizationID]
    WHERE [patMon].[PatientID] IN (SELECT [PatientID] FROM [#SelectedPatients])
    UNION ALL
    SELECT DISTINCT
           CAST(NULL AS INT) AS [PatientType],
           CAST(NULL AS INT) AS [HospService],
           CAST(NULL AS INT) AS [PatientClass],
           CAST(NULL AS INT) AS [AmbulatorySts],
           CAST(NULL AS NCHAR(2)) AS [VipIndicator],
           CAST(NULL AS INT) AS [DischargeDisposition],
           [vps].[AdmitDateTime] AS [AdmitDate],
           [vps].[DischargedDateTime] AS [DischargeDateTime],
           CAST(NULL AS NVARCHAR(40)) AS [VisitNumber],
           [vps].[PatientID] AS [PatientID],
           CAST(NULL AS INT) AS [SequenceNumber],
           [vps].[MonitorName] AS [NodeName],
           CAST(NULL AS NVARCHAR(15)) AS [NodeID],
           [vps].[Room],
           [vps].[Bed],
           [vps].[UnitName],
           [vps].[DeviceID]
    FROM [old].[vwPatientSessions] AS [vps]
    WHERE [PatientID] IN (SELECT [PatientID] FROM [#SelectedPatients])
          AND [vps].[Status] = 'A'
    ORDER BY [AdmitDate] DESC;

    --Get vitals

    --for ML patients (Legacy Tele)
    SELECT DISTINCT
           [VL].[PatientID],
           [VL].[MonitorID],
           [VL].[CollectionDateTime],
           [VL].[VitalValue],
           [VL].[VitalTime],
           [imrnm].[OrganizationID],
           [imrnm].[MedicalRecordNumberXID] AS [MedicalRecordNumber]
    FROM [Intesys].[VitalLiveTemporary] AS [VL]
        INNER JOIN [Intesys].[MedicalRecordNumberMap] AS [imrnm]
            ON [VL].[PatientID] = [imrnm].[PatientID]
        INNER JOIN [Intesys].[PatientMonitor] AS [PM]
            ON [VL].[PatientID] = [PM].[PatientID]
               AND [VL].[MonitorID] = [PM].[MonitorID]
    WHERE [VL].[PatientID] IN (SELECT [PatientID] FROM [#SelectedPatients])
          AND [imrnm].[MergeCode] = 'C'
          AND [VL].[CollectionDateTime] = (SELECT MAX([VL_SUBTAB].[CollectionDateTime])
                                           FROM [Intesys].[VitalLiveTemporary] AS [VL_SUBTAB]
                                           WHERE [VL_SUBTAB].[MonitorID] = [VL].[MonitorID]
                                                 AND [VL_SUBTAB].[PatientID] = [VL].[PatientID]
                                                 AND [VL_SUBTAB].[CreatedDateTime] > @LowerTimeLimit);

    --for DL patients
    SELECT
        [VitalsAll].[CodeID],
        [VitalsAll].[GlobalDataSystemCode] AS [Code],
        [VitalsAll].[Description] AS [Description],
        [VitalsAll].[Units],
        [VitalsAll].[Value] AS [ResultValue],
        '' AS [ValueTypeCode],
        NULL AS [ResultStatus],
        NULL AS [Probability],
        NULL AS [ReferenceRange],
        NULL AS [AbnormalNatureCode],
        NULL AS [AbnormalCode],
        [VitalsAll].[Timestamp] AS [ResultTime],
        [VitalsAll].[PatientID] AS [PatientID],
        [ds].[DeviceID]
    FROM (SELECT
              ROW_NUMBER() OVER (PARTITION BY
                                     [vpts].[PatientID],
                                     [gcm].[GlobalDataSystemCode]
                                 ORDER BY [ld].[Timestamp] DESC) AS [RowNumber],
              [ld].[FeedTypeID],
              [ld].[TopicInstanceID],
              [ld].[Name],
              [ld].[Value],
              [gcm].[GlobalDataSystemCode],
              [gcm].[CodeID],
              [gcm].[Units],
              [ld].[Timestamp],
              [vpts].[PatientID],
              [ts].[DeviceSessionID],
              [gcm].[Description]
          FROM [old].[LiveData] AS [ld]
              INNER JOIN [old].[TopicSession] AS [ts]
                  ON [ts].[TopicInstanceID] = [ld].[TopicInstanceID]
                     AND [ts].[EndDateTime] IS NULL
              INNER JOIN [old].[GlobalDataSystemCodeMap] AS [gcm]
                  ON [gcm].[FeedTypeID] = [ld].[FeedTypeID]
                     AND [gcm].[Name] = [ld].[Name]
              INNER JOIN [old].[vwPatientTopicSessions] AS [vpts]
                  ON [ts].[TopicSessionID] = [vpts].[TopicSessionID]
          WHERE [vpts].[PatientID] IN (SELECT [PatientID] FROM [#SelectedPatients])) AS [VitalsAll]
        INNER JOIN [old].[DeviceSession] AS [ds]
            ON [ds].[DeviceSessionID] = [VitalsAll].[DeviceSessionID]
    WHERE [VitalsAll].[RowNumber] = 1
          AND [VitalsAll].[Units] IS NOT NULL;

    DROP TABLE [#SelectedPatients];
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the vitals and other patient data of all the active patients to generate the Oru messages', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetLiveVitalsAndPatientDataForOru';

