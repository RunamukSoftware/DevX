CREATE PROCEDURE [dbo].[usp_GetMonitorList]
    (
    @filters NVARCHAR(MAX) = N'',
    @Debug BIT = 0)
AS
BEGIN
    DECLARE
        @QUERY NVARCHAR(MAX),
        @QUERY1 NVARCHAR(1000);

    SET @QUERY
        = N'
SELECT
    RTRIM([vm].[monitor_name]) AS [Name],
    RTRIM([vm].[network_id]) AS [Network ID],
    [vm].[node_id] AS [Node ID],
    [vm].[bed_id] AS [Bed ID],
    RTRIM([vm].[channel]) AS [Channel],
    [vm].[monitor_dsc] AS [Description],
    [FacilityOrg].[organization_cd] + N'' - '' + [UnitOrg].[organization_cd] AS [Unit],
    [vm].[room] AS [Room],
    RTRIM([vm].[bed_cd]) AS [Bed],
    [UnitOrg].[auto_collect_interval] AS [Interval],
    CASE
        WHEN [MaxTimeLocal].[LocalDateTime] IS NOT NULL THEN [MaxTimeLocal].[LocalDateTime]
        ELSE [LastPoll].[MaxPollDate]
    END AS [Last Used],
    CASE
        WHEN [MaxDeviceSession].[EndTimeUTC] IS NULL THEN ''Y''
        ELSE ''N''
    END AS [Active],
    [vm].[subnet],
    [vm].[monitor_id],
    [vm].[assignment_cd] AS [assignment_id]
FROM [dbo].[v_Monitors] AS [vm]
    LEFT OUTER JOIN [dbo].[int_organization] AS [UnitOrg]
        ON [UnitOrg].[organization_id] = [vm].[unit_org_id]
    LEFT OUTER JOIN [dbo].[int_organization] AS [FacilityOrg]
        ON [FacilityOrg].[organization_id] = [UnitOrg].[parent_organization_id]
    OUTER APPLY
    (
        SELECT
            [ipm].[monitor_id],
            MAX([ipm].[last_poll_dt]) AS [MaxPollDate]
        FROM [dbo].[int_patient_monitor] AS [ipm]
        WHERE [ipm].[monitor_id] = [vm].[monitor_id]
        GROUP BY [ipm].[monitor_id]
    ) AS [LastPoll]
    OUTER APPLY
    (
        SELECT TOP (1)
            [ds].[EndTimeUTC]
        FROM [dbo].[DeviceSessions] AS [ds]
        WHERE [ds].[DeviceId] = [vm].[monitor_id]
        ORDER BY [ds].[BeginTimeUTC] DESC
    ) AS [MaxDeviceSession]
    OUTER APPLY
    (
        SELECT TOP (1)
            [ds].[Id] AS [dsDeviceSessionId],
            [ds].[EndTimeUTC],
            [TopicVitals].[vdTimestampUTC]
        FROM [dbo].[DeviceSessions] AS [ds]
            CROSS APPLY
            (
                SELECT TOP (1)
                    [ts].[Id] AS [tsTopicSessionID],
                    [Vitals].[vdTimestampUTC]
                FROM [dbo].[TopicSessions] AS [ts]
                    CROSS APPLY
                    (
                        SELECT TOP (1)
                            [vd].[TimestampUTC] AS [vdTimestampUTC]
                        FROM [dbo].[VitalsData] AS [vd]
                        WHERE [vd].[TopicSessionId] = [ts].[Id]
                        ORDER BY [vd].[TimestampUTC] DESC
                    ) AS [Vitals]
                WHERE [ts].[DeviceSessionId] = [ds].[Id]
                ORDER BY [ts].[BeginTimeUTC] DESC
            ) AS [TopicVitals]
        WHERE [ds].[DeviceId] = [vm].[monitor_id]
        ORDER BY [ds].[BeginTimeUTC] DESC
    ) AS [DeviceTopicVitals]
    OUTER APPLY [dbo].[fntUtcDateTimeToLocalTime]([DeviceTopicVitals].[vdTimestampUTC]) AS [MaxTimeLocal]
'   ;

    SET @QUERY1 = N'
ORDER BY [Name];';

    IF (LEN(@filters) > 0)
    BEGIN
        SET @QUERY += N' WHERE ';
        SET @QUERY += @filters;
        SET @QUERY += @QUERY1;
    END;
    ELSE
    BEGIN
        SET @QUERY += @QUERY1;
    END;

    IF (@Debug = 1)
    BEGIN
        PRINT @QUERY;
    END;

    EXEC [sys].[sp_executesql] @QUERY;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve an optionally filtered list of the monitors attached to the ICS System.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetMonitorList';

