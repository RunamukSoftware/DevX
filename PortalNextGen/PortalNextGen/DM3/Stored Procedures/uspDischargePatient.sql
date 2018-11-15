CREATE PROCEDURE [DM3].[uspDischargePatient]
    (
        @DischargeDate DATETIME2(7) = NULL,
        @EncounterID   INT          = NULL,
        @MonitorID     INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@DischargeDate IS NULL)
            BEGIN
                SET @DischargeDate = SYSUTCDATETIME();
            END;

        BEGIN TRANSACTION;

        UPDATE
            [Intesys].[Encounter]
        SET
            [DischargeDateTime] = @DischargeDate,
            [StatusCode] = N'D'
        WHERE
            [EncounterID] = @EncounterID;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [ActiveSwitch] = NULL
        WHERE
            [MonitorID] = @MonitorID;

        COMMIT TRANSACTION;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspDischargePatient';

