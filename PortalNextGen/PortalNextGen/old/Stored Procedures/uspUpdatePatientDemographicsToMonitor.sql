CREATE PROCEDURE [old].[uspUpdatePatientDemographicsToMonitor] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [MonitorStatus] = 'UPD'
        WHERE
            [PatientID] = @PatientID
            AND [ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientDemographicsToMonitor';

