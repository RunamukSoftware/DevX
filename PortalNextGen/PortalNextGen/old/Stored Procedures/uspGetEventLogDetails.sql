CREATE PROCEDURE [old].[uspGetEventLogDetails]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iel].[Type],
            [iel].[EventDateTime],
            [iel].[Description],
            [iel].[Status],
            [origin].[MonitorName],
            [origin].[FirstName],
            [origin].[MiddleName],
            [origin].[LastName]
        FROM
            [Intesys].[EventLog] AS [iel]
            INNER JOIN
                (
                    SELECT
                        [ia].[AlarmID] AS [EventID],
                        [im].[MonitorName],
                        [ipe].[FirstName],
                        [ipe].[MiddleName],
                        [ipe].[LastName]
                    FROM
                        [Intesys].[Alarm]              AS [ia]
                        INNER JOIN
                            [Intesys].[PatientMonitor] AS [ipm]
                                ON [ipm].[PatientID] = [ia].[PatientID]
                        INNER JOIN
                            [Intesys].[Monitor]        AS [im]
                                ON [im].[MonitorID] = [ipm].[MonitorID]
                        INNER JOIN
                            [Intesys].[Person]         AS [ipe]
                                ON [ipe].[PersonID] = [ia].[PatientID]
                    WHERE
                        [ipm].[ActiveSwitch] = 1
                    UNION
                    SELECT
                        [vla].[LimitAlarmID] AS [EventID],
                        [vdsa].[MonitorName],
                        [vp].[FirstName],
                        [vp].[MiddleName],
                        [vp].[LastName]
                    FROM
                        [old].[vwLimitAlarms]                 AS [vla]
                        INNER JOIN
                            [old].[vwDeviceSessionAssignment] AS [vdsa]
                                ON [vdsa].[DeviceSessionID] = [vla].[DeviceSessionID]
                        INNER JOIN
                            [old].[vwPatientTopicSessions]    AS [vpts]
                                ON [vpts].[TopicSessionID] = [vla].[TopicSessionID]
                        INNER JOIN
                            [old].[vwPatients]                AS [vp]
                                ON [vp].[PatientID] = [vpts].[PatientID]
                    UNION
                    SELECT
                        [vga].[GeneralAlarmID] AS [EventID],
                        [vdsa].[MonitorName],
                        [vp].[FirstName],
                        [vp].[MiddleName],
                        [vp].[LastName]
                    FROM
                        [old].[vwGeneralAlarms]               AS [vga]
                        INNER JOIN
                            [old].[vwDeviceSessionAssignment] AS [vdsa]
                                ON [vdsa].[DeviceSessionID] = [vga].[DeviceSessionID]
                        INNER JOIN
                            [old].[vwPatientTopicSessions]    AS [vpts]
                                ON [vpts].[TopicSessionID] = [vga].[TopicSessionID]
                        INNER JOIN
                            [old].[vwPatients]                AS [vp]
                                ON [vp].[PatientID] = [vpts].[PatientID]
                )                AS [origin]
                    ON [origin].[EventID] = [iel].[EventID]
        ORDER BY
            [iel].[EventDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEventLogDetails';

