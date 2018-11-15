CREATE PROCEDURE [dbo].[SetPatientDataCollect]
    (
     @PatientId UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_patient_monitor]
    SET
        [live_until_dt] = DATEADD(MINUTE, 3, GETDATE( ))
    WHERE
        [patient_id] = @PatientId
        AND [active_sw] = 1;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SetPatientDataCollect';

