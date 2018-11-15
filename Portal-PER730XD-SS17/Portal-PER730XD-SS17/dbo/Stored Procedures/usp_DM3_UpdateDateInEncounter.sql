CREATE PROCEDURE [dbo].[usp_DM3_UpdateDateInEncounter]
    (
     @MonitorId NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @EncounterId NVARCHAR(50) = NULL -- TG - should be UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_encounter]
    SET
        [discharge_dt] = GETDATE(),
        [status_cd] = N'D'
    WHERE
        [status_cd] = N'C'
        AND [encounter_id] IN (SELECT
                                [encounter_id]
                               FROM
                                [dbo].[int_patient_monitor]
                               WHERE
                                [monitor_id] = CAST(@MonitorId AS UNIQUEIDENTIFIER)
                                AND [encounter_id] <> CAST(@EncounterId AS UNIQUEIDENTIFIER));
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update MonitorId and EncounterId in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_UpdateDateInEncounter';

