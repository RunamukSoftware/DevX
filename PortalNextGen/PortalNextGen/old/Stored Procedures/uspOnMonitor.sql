CREATE PROCEDURE [old].[uspOnMonitor]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ipm].[PatientID],
            CONVERT(CHAR(10), [imm].[MedicalRecordNumberXID]) AS [MedicalRecordNumber],
            [im].[MonitorName]                                AS [MONITOR],
            CONVERT(CHAR(15), [ipn].[LastName])               AS [LAST NAME],
            CONVERT(CHAR(15), [ipn].[FirstName])              AS [FIRST NAME],
            [ipm].[MonitorInterval]                           AS [INTERVAL],
            [ipm].[PollStartDateTime],
            [ipm].[PollEndDateTime],
            [ipm].[MonitorStatus],
            [ipm].[MonitorError]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [Intesys].[PersonName]         AS [ipn]
                    ON [imm].[PatientID] = [ipn].[PersonNameID]
            INNER JOIN
                [Intesys].[PatientMonitor]     AS [ipm]
                    ON [ipm].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [Intesys].[Monitor]            AS [im]
                    ON [ipm].[MonitorID] = [im].[MonitorID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspOnMonitor';

