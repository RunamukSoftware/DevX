CREATE PROCEDURE [CEI].[uspGetAlarmTextOnly]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ia].[AlarmID],
            [ia].[StartDateTime],
            [ia].[AlarmLevel],
            [ar].[Annotation],
            [imm].[MedicalRecordNumberXID],
            [imm].[MedicalRecordNumberXID2],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [ipe].[LastName],
            [ipe].[PersonID],
            [io].[OrganizationCode],
            [im].[NodeID],
            [im].[MonitorName]
        FROM
            [Intesys].[Alarm]                      AS [ia]
            INNER JOIN
                [Intesys].[AlarmRetrieved]         AS [ar]
                    ON [ia].[AlarmID] = [ar].[AlarmID]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ia].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ia].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [ipm]
                    ON [ia].[PatientID] = [ipm].[PatientID]
                       AND [ipm].[ActiveSwitch] = 1
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [ipm].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[Organization]           AS [io]
                    ON [im].[UnitOrganizationID] = [io].[OrganizationID]
        WHERE
            [ar].[Retrieved] = 0
            AND [imm].[MergeCode] = 'C';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CEI Procedures - QueryTextOnly - GetAlarmTextOnly', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetAlarmTextOnly';

