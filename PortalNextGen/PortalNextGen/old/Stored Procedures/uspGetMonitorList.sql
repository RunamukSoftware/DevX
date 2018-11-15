CREATE PROCEDURE [old].[uspGetMonitorList]
    (
        @Filters NVARCHAR(MAX) = N'',
        @Debug   BIT           = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @SqlQuery NVARCHAR(MAX),
            @OrderBy  NVARCHAR(1000);

        SET @SqlQuery
            = N'
SELECT
    RTRIM([vm].[MonitorName]) AS [Name],
    RTRIM([vm].[NetworkID]) AS [Network ID],
    [vm].[NodeID] AS [Node ID],
    [vm].[bedID] AS [Bed ID],
    RTRIM([vm].[channel]) AS [Channel],
    [vm].[monitorDescription] AS [Description],
    [FacilityOrg].[OrganizationCode] + N'' - '' + [UnitOrg].[OrganizationCode] AS [Unit],
    [vm].[Room] AS [Room],
    RTRIM([vm].[bedCode]) AS [Bed],
    [UnitOrg].[AutoCollectInterval] AS [Interval],
    CASE
        WHEN [MaxTimeLocal].[LocalDateTime] IS NOT NULL THEN [MaxTimeLocal].[LocalDateTime]
        ELSE [LastPoll].[MaxPollDate]
    END AS [Last Used],
    CASE
        WHEN [MaxDeviceSession].[EndDateTime] IS NULL THEN ''Y''
        ELSE ''N''
    END AS [Active],
    [vm].[Subnet],
    [vm].[MonitorID],
    [vm].[assignmentCode] AS [assignmentID]
FROM [old].[vwMonitors] AS [vm]
    LEFT OUTER JOIN [Intesys].[organization] AS [UnitOrg]
        ON [UnitOrg].[OrganizationID] = [vm].[UnitOrganizationID]
    LEFT OUTER JOIN [Intesys].[organization] AS [FacilityOrg]
        ON [FacilityOrg].[OrganizationID] = [UnitOrg].[ParentOrganizationID]
    OUTER APPLY
    (
        SELECT
            [ipm].[MonitorID],
            MAX([ipm].[LastPollingDateTime]) AS [MaxPollDate]
        FROM [Intesys].[patient_monitor] AS [ipm]
        WHERE [ipm].[MonitorID] = [vm].[MonitorID]
        GROUP BY [ipm].[MonitorID]
    ) AS [LastPoll]
    OUTER APPLY
    (
        SELECT TOP (1)
            [ds].[EndDateTime]
        FROM [old].[DeviceSessions] AS [ds]
        WHERE [ds].[DeviceID] = [vm].[MonitorID]
        ORDER BY [ds].[BeginDateTime] DESC
    ) AS [MaxDeviceSession]
    OUTER APPLY
    (
        SELECT TOP (1)
            [ds].[DeviceSessionID] AS [dsDeviceSessionID],
            [ds].[EndDateTime],
            [TopicVitals].[vdTimestamp]
        FROM [old].[DeviceSessions] AS [ds]
            CROSS APPLY
             (
                 SELECT TOP (1)
                     [ts].[TopicSessionID],
                     [Vitals].[vdTimestamp]
                 FROM [old].[TopicSessions] AS [ts]
                     CROSS APPLY
                      (
                          SELECT TOP (1)
                              [vd].[Timestamp] AS [vdTimestamp]
                          FROM [old].[VitalsData] AS [vd]
                          WHERE [vd].[TopicSessionID] = [ts].[TopicSessionID]
                          ORDER BY [vd].[Timestamp] DESC
                      ) AS [Vitals]
                 WHERE [ts].[DeviceSessionID] = [ds].[DeviceSessionID]
                 ORDER BY [ts].[BeginDateTime] DESC
             ) AS [TopicVitals]
        WHERE [ds].[DeviceID] = [vm].[MonitorID]
        ORDER BY [ds].[BeginDateTime] DESC
    ) AS [DeviceTopicVitals]
    OUTER APPLY [old].[fntUtcDateTimeToLocalTime]([DeviceTopicVitals].[vdTimestamp]) AS [MaxTimeLocal]
'       ;

        SET @OrderBy = N'
ORDER BY [Name];';

        IF (LEN(@Filters) > 0)
            BEGIN
                SET @SqlQuery += N' WHERE ' + @Filters;
            END;

        SET @SqlQuery += @OrderBy;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC [sys].[sp_executesql]
            @SqlQuery;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve an optionally filtered list of the monitors attached to the ICS System.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetMonitorList';

