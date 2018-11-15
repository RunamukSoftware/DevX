CREATE PROCEDURE [DM3].[uspUpdateDateInEncounter]
    (
        @MonitorID   INT = NULL,
        @EncounterID INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Encounter]
        SET
            [DischargeDateTime] = SYSUTCDATETIME(),
            [StatusCode] = N'D'
        WHERE
            [StatusCode] = N'C'
            AND [EncounterID] IN (
                                     SELECT
                                         [ipm].[EncounterID]
                                     FROM
                                         [Intesys].[PatientMonitor] AS [ipm]
                                     WHERE
                                         [ipm].[MonitorID] = @MonitorID
                                         AND [ipm].[EncounterID] <> @EncounterID
                                 );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update MonitorID and EncounterID in DM3 Loader.', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdateDateInEncounter';

