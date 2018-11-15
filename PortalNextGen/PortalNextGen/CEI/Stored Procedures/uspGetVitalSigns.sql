CREATE PROCEDURE [CEI].[uspGetVitalSigns]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ivl].[PatientID],
            [ivl].[CollectionDateTime],
            [ivl].[VitalValue],
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
            [Intesys].[VitalLive]                  AS [ivl]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ivl].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ivl].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [ivl].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[PatientMonitor]         AS [ipm]
                    ON [ivl].[PatientID] = [ipm].[PatientID]
                       AND [ipm].[ActiveSwitch] = 1
            INNER JOIN
                [Intesys].[Organization]           AS [io]
                    ON [im].[UnitOrganizationID] = [io].[OrganizationID]
        WHERE
            [imm].[MergeCode] = 'C';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetVitalSigns';

