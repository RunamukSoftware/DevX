CREATE VIEW [old].[vwMonitors]
WITH SCHEMABINDING
AS
    SELECT
        [im].[MonitorID],
        [im].[UnitOrganizationID],
        [im].[NetworkID],
        [im].[NodeID],
        [im].[BedID],
        NULL  AS [channel],
        [im].[BedCode],
        [im].[Room],
        [im].[MonitorDescription],
        [im].[MonitorName],
        [im].[MonitorTypeCode],
        [im].[Subnet],
        'ICS' AS [AssignmentCode]
    FROM
        [Intesys].[Monitor] AS [im]
    UNION ALL
    SELECT
        [d].[DeviceID]                  AS [MonitorID],
        [FacilityUnit].[OrganizationID] AS [UnitOrganizationID],
        [DeviceInfoFarm].[Value]        AS [NetworkID],
        NULL                            AS [NodeID],
        NULL                            AS [BedID],
        [DeviceInfoTransmitter].[Value] AS [Channel],
        [DeviceInfoBed].[Value]         AS [BedCode],
        [d].[Room]                      AS [Room],
        [d].[Description]               AS [monitorDescription],
        [DeviceInfoDeviceName].[Value]  AS [MonitorName],
        NULL                            AS [MonitorTypeCode],
        NULL                            AS [Subnet],
        CASE
            WHEN [DeviceInfoDeviceType].[Value] = N'ETtransmitter'
                THEN 'DEVICE'
            ELSE
                'ICS'
        END                             AS [AssignmentCode]
    FROM
        [old].[Device] AS [d]
        OUTER APPLY
        (
            SELECT
                [x].[DeviceSessionID],
                [x].[DeviceID],
                [x].[RowNumber]
            FROM
                (
                    SELECT
                        [ds].[DeviceSessionID] AS [DeviceSessionID],
                        [ds].[DeviceID],
                        ROW_NUMBER() OVER (PARTITION BY
                                               [ds].[DeviceID]
                                           ORDER BY
                                               [ds].[BeginDateTime] DESC
                                          )    AS [RowNumber]
                    FROM
                        [old].[DeviceSession] AS [ds]
                    WHERE
                        [ds].[DeviceID] = [d].[DeviceID]
                ) AS [x]
            WHERE
                [x].[RowNumber] = 1
        )              AS [LatestSession]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'DeviceType') AS [DeviceInfoDeviceType]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'Farm') AS [DeviceInfoFarm]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'Transmitter') AS [DeviceInfoTransmitter]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'DeviceName') AS [DeviceInfoDeviceName]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'Bed') AS [DeviceInfoBed]
        OUTER APPLY [old].[fntDeviceInfoSelect]([LatestSession].[DeviceSessionID], N'Unit') AS [InfoUnit]
        LEFT OUTER JOIN
            (
                SELECT
                    [Units].[OrganizationID]                                            AS [OrganizationID],
                    [Facilities].[OrganizationName] + N'+' + [Units].[OrganizationName] AS [Facility Unit]
                FROM
                    [Intesys].[Organization]     AS [Facilities]
                    INNER JOIN
                        [Intesys].[Organization] AS [Units]
                            ON [Units].[ParentOrganizationID] = [Facilities].[OrganizationID]
            ) AS [FacilityUnit]
                ON [InfoUnit].[Value] = [FacilityUnit].[Facility Unit];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwMonitors';

