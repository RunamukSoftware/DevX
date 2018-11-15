CREATE PROCEDURE [old].[uspSetPatientDataCollect] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [LiveUntilDateTime] = DATEADD(MINUTE, 3, GETDATE())
        WHERE
            [PatientID] = @PatientID
            AND [ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSetPatientDataCollect';

