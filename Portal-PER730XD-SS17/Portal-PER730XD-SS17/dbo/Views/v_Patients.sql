CREATE VIEW [dbo].[v_Patients]
WITH
     SCHEMABINDING
AS
SELECT DISTINCT
    [patient_id],
    [FIRST_NAME],
    [MIDDLE_NAME],
    [LAST_NAME],
    [patient_name],
    [MRN_ID] AS [ID1],
    [ACCOUNT_ID] AS [ID2],
    [DOB],
    [FACILITY_NAME]
FROM
    [dbo].[v_PatientSessions];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_Patients';

