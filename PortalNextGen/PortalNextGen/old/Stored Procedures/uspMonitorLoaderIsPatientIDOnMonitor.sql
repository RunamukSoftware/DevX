CREATE PROCEDURE [old].[uspMonitorLoaderIsPatientIDOnMonitor]
    (
        @PatientID AS          VARCHAR(20),
        @CurrentMonitor AS VARCHAR(10) = ''
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF @CurrentMonitor IS NULL
            SET @CurrentMonitor = '';

        SELECT
            [ipm].[ActiveSwitch],
            [im].[MonitorName],
            [im].[Standby]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
            LEFT OUTER JOIN
                [Intesys].[PatientMonitor]     AS [ipm]
                    ON [imm].[PatientID] = [ipm].[PatientID]
                       AND [ipm].[ActiveSwitch] = 1
            LEFT OUTER JOIN
                [Intesys].[Monitor]            AS [im]
                    ON [ipm].[MonitorID] = [im].[MonitorID]
        WHERE
            [imm].[MedicalRecordNumberXID] = @PatientID
            AND [im].[MonitorName] <> @CurrentMonitor
            AND [ipm].[ActiveSwitch] = 1
            AND [imm].[MergeCode] = 'C'
            AND [im].[Standby] IS NULL
        UNION
        SELECT TOP (1)
            CAST(1 AS TINYINT) AS [ActiveSwitch],
            N'ET'              AS [MonitorName],
            CASE [MonitoringStatus].[Value]
                WHEN N'Standby'
                    THEN 1
                ELSE
                    NULL
            END                AS [standby]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[PatientID] = [imm].[PatientID]
            INNER JOIN
                [old].[TopicSession]           AS [ts]
                    ON [ts].[TopicSessionID] = [vpts].[TopicSessionID]
            LEFT OUTER JOIN
                (
                    SELECT
                        [did].[DeviceSessionID],
                        [did].[Name],
                        [did].[Value],
                        ROW_NUMBER() OVER (PARTITION BY
                                               [did].[DeviceSessionID],
                                               [did].[Name]
                                           ORDER BY
                                               [did].[DateTimeStamp] DESC
                                          ) AS [RowNumber]
                    FROM
                        [old].[DeviceInformation] AS [did]
                    WHERE
                        [did].[Name] = N'MonitoringStatus'
                )                              AS [MonitoringStatus]
                    ON [MonitoringStatus].[DeviceSessionID] = [ts].[DeviceSessionID]
                       AND [MonitoringStatus].[RowNumber] = 1
        WHERE
            [imm].[MedicalRecordNumberXID] = @PatientID
            AND [imm].[MergeCode] = 'C'
            AND [ts].[EndDateTime] IS NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspMonitorLoaderIsPatientIDOnMonitor';

