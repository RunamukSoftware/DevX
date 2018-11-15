CREATE PROCEDURE [dbo].[usp_DM3_UpdateLastPoleDate_ResultDate_in_patientmonitor]
    (
     @Last_Poll_Date NVARCHAR(30) = NULL, -- TG - should be DATETIME
     @PatientGUID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @PatientMonitorGUID NVARCHAR(50) -- TG - should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_patient_monitor]
    SET
        [last_poll_dt] = CAST(@Last_Poll_Date AS DATETIME),
        [last_result_dt] = CAST(@Last_Poll_Date AS DATETIME)
    WHERE
        [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
        AND [patient_monitor_id] = CAST(@PatientMonitorGUID AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_UpdateLastPoleDate_ResultDate_in_patientmonitor';

