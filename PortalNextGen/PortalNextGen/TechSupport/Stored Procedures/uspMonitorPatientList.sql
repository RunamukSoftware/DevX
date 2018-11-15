CREATE PROCEDURE [TechSupport].[uspMonitorPatientList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [im].[NetworkID],
            [im].[NodeID],
            [im].[BedID],
            [im].[Room],
            [im].[MonitorName],
            [im].[Subnet],
            [imm].[MedicalRecordNumberXID],
            [imm].[MedicalRecordNumberXID2],
            [imm].[AdmitDischargeTransferAdmitSwitch],
            [ipe].[FirstName],
            [ipe].[MiddleName],
            [ipe].[LastName],
            [ie].[AdmitDateTime],
            [ipm].[MonitorInterval],
            [ipm].[LastPollingDateTime],
            [ipm].[LastResultDateTime],
            [ipm].[LastEpisodicDateTime],
            [ipm].[LastOutboundDateTime],
            [ipm].[MonitorStatus],
            [ipm].[MonitorConnectDateTime]
        FROM
            [Intesys].[PatientMonitor]             AS [ipm]
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [ipm].[MonitorID] = [im].[MonitorID]
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipm].[PatientID] = [ipe].[PersonID]
            INNER JOIN
                [Intesys].[Encounter]              AS [ie]
                    ON [ipm].[PatientID] = [ie].[PatientID]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [imm]
                    ON [ipm].[PatientID] = [imm].[PatientID]
        WHERE
            [ipm].[ActiveSwitch] = 1
            AND [imm].[MergeCode] = 'C'
        ORDER BY
            [im].[NodeID],
            [im].[BedID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'TechSupport', @level1type = N'PROCEDURE', @level1name = N'uspMonitorPatientList';

