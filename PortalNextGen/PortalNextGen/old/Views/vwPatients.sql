CREATE VIEW [old].[vwPatients]
WITH SCHEMABINDING
AS
    SELECT DISTINCT
        [vps].[PatientID],
        [vps].[FirstName],
        [vps].[MiddleName],
        [vps].[LastName],
        [vps].[MedicalRecordNumberID] AS [ID1],
        [vps].[AccountID]             AS [ID2],
        [vps].[DateOfBirth],
        [vps].[FacilityName]
    FROM
        [old].[vwPatientSessions] AS [vps];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwPatients';

