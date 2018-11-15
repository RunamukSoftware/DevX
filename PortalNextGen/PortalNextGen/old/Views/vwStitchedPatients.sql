CREATE VIEW [old].[vwStitchedPatients]
WITH SCHEMABINDING
AS
    SELECT
        [vps].[PatientID],
        [vps].[FirstName],
        [vps].[MiddleName],
        [vps].[LastName],
        [vps].[MonitorName],
        [vps].[AccountID],
        [vps].[MedicalRecordNumberID],
        [vps].[UnitID],
        [vps].[UnitName],
        [vps].[UnitCode],
        [vps].[FacilityID],
        [vps].[FacilityName],
        [vps].[FacilityCode],
        [vps].[DateOfBirth],
        MIN([vps].[AdmitDateTime])      AS [AdmitDateTime],
        MAX([vps].[DischargedDateTime]) AS [DischargedTime],
        [vps].[PatientMonitorID],
        [vps].[Status]
    FROM
        [old].[vwPatientSessions] AS [vps]
    GROUP BY
        [vps].[PatientID],
        [vps].[FirstName],
        [vps].[MiddleName],
        [vps].[LastName],
        [vps].[MonitorName],
        [vps].[AccountID],
        [vps].[MedicalRecordNumberID],
        [vps].[UnitID],
        [vps].[UnitName],
        [vps].[UnitCode],
        [vps].[FacilityID],
        [vps].[FacilityName],
        [vps].[FacilityCode],
        [vps].[DateOfBirth],
        [vps].[PatientMonitorID],
        [vps].[Status];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwStitchedPatients';

