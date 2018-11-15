
CREATE VIEW [dbo].[v_StitchedPatients]
WITH
     SCHEMABINDING
AS
SELECT
    [patient_id],
    [patient_name],
    [FIRST_NAME],
    [MIDDLE_NAME],
    [LAST_NAME],
    [MONITOR_NAME],
    [ACCOUNT_ID],
    [MRN_ID],
    [UNIT_ID],
    [UNIT_NAME],
    [UNIT_CODE],
    [FACILITY_ID],
    [FACILITY_NAME],
    [FACILITY_CODE],
    [DOB],
    --[dbo].[fnUtcDateTimeToLocalTime](MIN([ADMIT_TIME_UTC])) AS [ADMIT_TIME],
    --[dbo].[fnUtcDateTimeToLocalTime](MAX([DISCHARGED_TIME_UTC])) AS [DISCHARGED_TIME],
    MIN([ADMIT_TIME].[LocalDateTime]) AS [ADMIT_TIME],
    MAX([DISCHARGED_TIME].[LocalDateTime]) AS [DISCHARGED_TIME],
    [PATIENT_MONITOR_ID],
    [STATUS]
FROM
    [dbo].[v_PatientSessions]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([ADMIT_TIME_UTC]) AS [ADMIT_TIME]
    CROSS APPLY [dbo].[fntUtcDateTimeToLocalTime]([DISCHARGED_TIME_UTC]) AS [DISCHARGED_TIME]
GROUP BY
    [patient_id],
    [patient_name],
    [FIRST_NAME],
    [MIDDLE_NAME],
    [LAST_NAME],
    [MONITOR_NAME],
    [ACCOUNT_ID],
    [MRN_ID],
    [UNIT_ID],
    [UNIT_NAME],
    [UNIT_CODE],
    [FACILITY_ID],
    [FACILITY_NAME],
    [FACILITY_CODE],
    [DOB],
    [PATIENT_MONITOR_ID],
    [STATUS];

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_StitchedPatients';

