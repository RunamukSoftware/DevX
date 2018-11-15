CREATE PROCEDURE [old].[uspGetPatientMonitorData] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipm].[PatientMonitorID],
            [ipm].[PatientID],
            [MedicalRecordNumber].[MedicalRecordNumberXID],
            [ipe].[FirstName],
            [ipe].[LastName],
            [im].[MonitorName],
            [ipm].[MonitorConnectDateTime]
        FROM
            [Intesys].[PatientMonitor]             AS [ipm]
            INNER JOIN
                [Intesys].[Monitor]                AS [im]
                    ON [im].[MonitorID] = [ipm].[MonitorID]
            INNER JOIN
                [Intesys].[MedicalRecordNumberMap] AS [MedicalRecordNumber]
                    ON [MedicalRecordNumber].[PatientID] = [ipm].[PatientID]
                       AND [MedicalRecordNumber].[MergeCode] = 'C'
            INNER JOIN
                [Intesys].[Person]                 AS [ipe]
                    ON [ipe].[PersonID] = [ipm].[PatientID]
        WHERE
            [ipm].[PatientID] = @PatientID
        UNION ALL
        SELECT
            [vps].[PatientMonitorID],
            [vps].[PatientID],
            [vps].[MedicalRecordNumberID] AS [MedicalRecordNumberXID],
            [vps].[FirstName],
            [vps].[LastName],
            [vps].[MonitorName],
            [vps].[AdmitDateTime]
        FROM
            [old].[vwPatientSessions] AS [vps]
        WHERE
            [vps].[PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientMonitorData';

