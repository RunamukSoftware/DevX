CREATE PROCEDURE [User].[uspGetUserPatientList]
    (
        @UnitID          VARCHAR(40),
        @Status          NVARCHAR(40),
        @IsVipSearchable BIT = 0,
        @Debug           BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery VARCHAR(MAX);

        SET @SqlQuery
            = '
(
SELECT int_MedicalRecordNumbermap.PatientID AS PatientID,
    ISNULL(int_person.LastName,'''') + ISNULL('', '' + int_person.FirstName,'''') AS patient_name,
    int_monitor.monitor_name AS MONITOR_NAME,
    int_MedicalRecordNumbermap.MedicalRecordNumberXID2 AS AccountID,
    int_MedicalRecordNumbermap.MedicalRecordNumberXID AS MedicalRecordNumberID,
    int_monitor.UnitOrganizationID AS UNITID,
    CHILD.OrganizationCode AS UNIT_NAME,
    PARENT.OrganizationID AS FACILITYID,
    PARENT.OrganizationName AS FACILITY_NAME,  
    int_patient.DateOfBirth AS DateOfBirth,
    int_encounter.admit_dt AS AdmitTime,
    int_encounter.discharge_dt AS DischargedTime,
    [ipm].PatientMonitorID AS PATIENT_MONITORID,
    CASE
        WHEN int_encounter.discharge_dt IS NULL AND ActiveSwitch = 1 THEN ''A'' 
        ELSE ''D''
    END AS [Status] 
FROM dbo.int_encounter
    LEFT OUTER JOIN [Intesys].[PatientMonitor] AS [ipm] ON int_encounter.EncounterID = [ipm].EncounterID
    AND int_encounter.PatientID = [ipm].PatientID
    INNER JOIN dbo.int_person ON int_encounter.PatientID = int_person.personID
    INNER JOIN dbo.int_patient ON int_person.personID = int_patient.PatientID
    INNER JOIN dbo.int_MedicalRecordNumbermap ON int_patient.PatientID = int_MedicalRecordNumbermap.PatientID
    INNER JOIN dbo.int_monitor ON PatientMonitor.MonitorID = int_monitor.MonitorID
    INNER JOIN dbo.int_organization  AS CHILD ON int_monitor.UnitOrganizationID = CHILD.OrganizationID
    LEFT OUTER JOIN dbo.int_organization AS PARENT ON PARENT.OrganizationID = CHILD.ParentOrganizationID                                        
WHERE
    int_monitor.UnitOrganizationID = ';
        SET @SqlQuery += '''';
        SET @SqlQuery += @UnitID;
        SET @SqlQuery += '''';
        SET @SqlQuery += ' AND int_MedicalRecordNumbermap.MergeCode = ''C'' ';

        IF (@Status = 'ACTIVE')
            SET @SqlQuery += ' AND int_encounter.discharge_dt IS NULL AND PatientMonitor.ActiveSwitch = 1 ';

        IF (@Status = 'DISCHARGED')
            SET @SqlQuery += ' AND int_encounter.discharge_dt IS NOT NULL ';

        IF (@IsVipSearchable <> '1')
            SET @SqlQuery += '  AND int_encounter.vipSwitch IS NULL ';

        SET @SqlQuery += ' ) UNION (
        SELECT
            [PatientID],
            [patient_name],
            [MonitorName],
            [AccountID],
            [MedicalRecordNumberID],
            [UnitID],
            [UNIT_NAME],
            [FacilityID],
            [FACILITY_NAME],
            [DateOfBirth],
            [AdmitTime],
            [DischargedTime],
            [PatientMonitorID],
            [Status]
        FROM [old].[vwStitchedPatients] WHERE ';

        SET @SqlQuery += ' [UnitID] = ''';
        SET @SqlQuery += @UnitID;
        SET @SqlQuery += '''';

        IF (@Status = 'ACTIVE')
            SET @SqlQuery += ' AND ([Status] = ''A'' OR [Status] = ''S'') ';

        IF (@Status = 'DISCHARGED')
            SET @SqlQuery += ' AND [Status] = ''D'' ';

        SET @SqlQuery += ' AND [PatientID] IS NOT NULL ';

        SET @SqlQuery += ') ORDER BY [AdmitTime] DESC,
                                        [patient_name],
                                        [MonitorName]';

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'PROCEDURE', @level1name = N'uspGetUserPatientList';

