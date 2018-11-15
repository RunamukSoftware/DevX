CREATE PROCEDURE [dbo].[usp_UpdatePatientDemographicsToMonitor]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_patient_monitor]
    SET
        [monitor_status] = 'UPD'
    WHERE
        [patient_id] = @patient_id
        AND [active_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdatePatientDemographicsToMonitor';

