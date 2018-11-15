CREATE PROCEDURE [HL7].[uspGetLiveVitalsAndPatientDataByQuery]
    (
    @QRYItem NVARCHAR(80),
    @Type INT = -1)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PatientID INT;

    SET @PatientID = [old].[ufnHL7GetPatientIDFromQueryItemType](@QRYItem, @Type);

    --Person and Patient data for PID
    SELECT DISTINCT
           [ipa].[DateOfBirth],
           [ipa].[GenderCodeID],
           [ipa].[DeathDate],
           [ipe].[FirstName],
           [ipe].[MiddleName],
           [ipe].[LastName],
           [imm].[MedicalRecordNumberXID2] AS [AccountNumber],
           [imm].[MedicalRecordNumberXID] AS [MedicalRecordNumber],
           [imm].[PatientID],
           [ipm].[MonitorID] AS [DeviceID]
    FROM [Intesys].[Patient] AS [ipa]
        INNER JOIN [Intesys].[Person] AS [ipe]
            ON [ipa].[PatientID] = [ipe].[PersonID]
               AND [ipa].[PatientID] = @PatientID
        INNER JOIN [Intesys].[MedicalRecordNumberMap] AS [imm]
            ON [ipa].[PatientID] = [imm].[PatientID]
        INNER JOIN [Intesys].[PatientMonitor] AS [ipm]
            ON [ipa].[PatientID] = [ipm].[PatientID]
    WHERE [imm].[MergeCode] = 'C'
    UNION ALL
    SELECT
        NULL AS [DateOfBirth],
        NULL AS [GenderCode],
        NULL AS [DeathDate],
        [vps].[FirstName],
        [vps].[MiddleName],
        [vps].[LastName],
        [vps].[AccountID] AS [AccountNumber],
        [vps].[MedicalRecordNumberID] AS [MedicalRecordNumber],
        [vps].[PatientID],
        [vps].[DeviceID]
    FROM [old].[vwPatientSessions] AS [vps]
    WHERE [vps].[PatientID] = @PatientID
          AND [vps].[Status] = 'A'; -- Per Alex Beechie - Bug # 10012

    --Get Order data
    SELECT TOP (1)
           [OrderNumber].[Value] AS [OrderID],
           [ig].[SendingApplication],
           CAST([OrderStatus].[Value] AS INT) AS [OrderStatus],
           CAST(NULL AS DATETIME2(7)) AS [OrderDateTime],
           @PatientID AS [PatientID]
    FROM [Intesys].[Gateway] AS [ig]
        CROSS JOIN (SELECT [as].[Value]
                    FROM [old].[ApplicationSetting] AS [as]
                    WHERE [as].[Key] = 'DefaultFillerOrderStatus') AS [OrderStatus]
        CROSS JOIN (SELECT [as2].[Value]
                    FROM [old].[ApplicationSetting] AS [as2]
                    WHERE [as2].[Key] = 'DefaultFillerOrderNumber') AS [OrderNumber];

    -- Get OBR
    SELECT DISTINCT
           [OrderNumber].[Value] AS [OrderID],
           [ig].[SendingApplication] AS [SendingApplication],
           CAST(NULL AS DATETIME2(7)) AS [OrderDateTime]
    FROM [Intesys].[Gateway] AS [ig]
        CROSS JOIN (SELECT [as].[Value]
                    FROM [old].[ApplicationSetting] AS [as]
                    WHERE [as].[Key] = 'DefaultFillerOrderNumber') AS [OrderNumber];

    --Patient visit/encounter information
    SELECT
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
        [patMon].[MonitorID] AS [DeviceID]
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
          AND [enc].[DischargeDateTime] IS NULL
    UNION ALL
    SELECT DISTINCT
           CAST(NULL AS INT) AS [PatientType],
           CAST(NULL AS INT) AS [HospService],
           CAST(NULL AS INT) AS [PatientClass],
           CAST(NULL AS INT) AS [AmbulatorySts],
           CAST(NULL AS NCHAR(2)) AS [VipIndicator],
           CAST(NULL AS INT) AS [DischargeDisposition],
           [AdmitDateTime] AS [AdmitDate],
           [DischargedDateTime] AS [DischargeDateTime],
           CAST(NULL AS NVARCHAR(40)) AS [VisitNumber],
           [PatientID] AS [PatientID],
           CAST(NULL AS INT) AS [SequenceNumber],
           [MonitorName] AS [NodeName],
           CAST(NULL AS NVARCHAR(15)) AS [NodeID],
           [Room],
           [Bed],
           [UnitName],
           [DeviceID]
    FROM [old].[vwPatientSessions]
    WHERE [PatientID] = @PatientID
          AND [DischargedDateTime] IS NULL -- Per Alex Beechie - Bug # 10012
    ORDER BY [AdmitDate] DESC;

    --Get vitals

    -- Create the equivalent date time to (GETDATE( ) - 0.002)
    DECLARE @LowerTimeLimit DATETIME2(7) = DATEADD(MILLISECOND, -172800, SYSUTCDATETIME());

    -- For ML patients (Legacy Tele)
    SELECT DISTINCT
           [vl].[PatientID],
           [vl].[MonitorID],
           [vl].[CollectionDateTime],
           [vl].[VitalValue] AS [Vitals],
           [vl].[VitalTime],
           [imm].[OrganizationID],
           [imm].[MedicalRecordNumberXID] AS [MedicalRecordNumber]
    FROM [Intesys].[VitalLiveTemporary] AS [vl]
        INNER JOIN [Intesys].[MedicalRecordNumberMap] AS [imm]
            ON [vl].[PatientID] = [imm].[PatientID]
        INNER JOIN [Intesys].[PatientMonitor] AS [pm]
            ON [vl].[PatientID] = [pm].[PatientID]
               AND [vl].[MonitorID] = [pm].[MonitorID]
    WHERE [vl].[PatientID] = @PatientID
          AND [imm].[MergeCode] = 'C'
          AND [vl].[CreatedDateTime] = (SELECT MAX([VL_SUBTAB].[CreatedDateTime])
                                        FROM [Intesys].[VitalLiveTemporary] AS [VL_SUBTAB]
                                        WHERE [VL_SUBTAB].[MonitorID] = [vl].[MonitorID]
                                              AND [VL_SUBTAB].[PatientID] = [vl].[PatientID]
                                              AND [VL_SUBTAB].[CreatedDateTime] > @LowerTimeLimit)
    ORDER BY [vl].[PatientID];

    -- For DL patients
    SELECT
        [VitalsAll].[CodeID],
        [VitalsAll].[GlobalDataSystemCode] AS [Code],
        [VitalsAll].[Description] AS [Description],
        [VitalsAll].[Units],
        [VitalsAll].[Value] AS [ResultValue],
        N'' AS [ValueTypeCode],
        NULL AS [ResultStatus],
        NULL AS [Probability],
        NULL AS [ReferenceRange],
        NULL AS [AbnormalNatureCode],
        NULL AS [AbnormalCode],
        [VitalsAll].[Timestamp] AS [ResultTime],
        [VitalsAll].[PatientID] AS [PatientID]
    FROM (SELECT
              ROW_NUMBER() OVER (PARTITION BY
                                     [PatientID],
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
              [PatientID],
              [gcm].[Description]
          FROM [old].[LiveData] AS [ld]
              INNER JOIN [old].[TopicSession] AS [ts]
                  ON [ts].[TopicInstanceID] = [ld].[TopicInstanceID]
                     AND [ts].[EndDateTime] IS NULL
              INNER JOIN [old].[GlobalDataSystemCodeMap] AS [gcm]
                  ON [gcm].[FeedTypeID] = [ld].[FeedTypeID]
                     AND [gcm].[Name] = [ld].[Name]
              INNER JOIN [old].[vwPatientTopicSessions]
                  ON [ts].[TopicSessionID] = [vwPatientTopicSessions].[TopicSessionID]
          WHERE [PatientID] = @PatientID) AS [VitalsAll]
    WHERE [VitalsAll].[RowNumber] = 1
          AND [VitalsAll].[Units] IS NOT NULL;
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the vitals and other patient data of all the active patients to generate the Oru messages', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetLiveVitalsAndPatientDataByQuery';

