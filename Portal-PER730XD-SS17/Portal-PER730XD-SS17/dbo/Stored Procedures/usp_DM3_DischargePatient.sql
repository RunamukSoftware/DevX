CREATE PROCEDURE [dbo].[usp_DM3_DischargePatient]
    (
     @DischargeDate NVARCHAR(50) = NULL, -- TG - should be DATETIME
     @EncounterIDGUID NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @MonitorID NVARCHAR(50) -- TG - should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    IF (@DischargeDate = 'NULL')
    BEGIN    
        SET @DischargeDate = CAST(GETDATE() AS NVARCHAR(50));
    END;

    UPDATE
        [dbo].[int_encounter]
    SET
        [discharge_dt] = CAST(@DischargeDate AS DATETIME),
        [status_cd] = N'D'
    WHERE
        [encounter_id] = CAST(@EncounterIDGUID AS UNIQUEIDENTIFIER);

    UPDATE
        [dbo].[int_patient_monitor]
    SET
        [active_sw] = NULL
    WHERE
        [monitor_id] = CAST(@MonitorID AS UNIQUEIDENTIFIER);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_DischargePatient';

