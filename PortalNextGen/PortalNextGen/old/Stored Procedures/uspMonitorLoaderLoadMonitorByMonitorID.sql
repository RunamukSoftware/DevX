CREATE PROCEDURE [old].[uspMonitorLoaderLoadMonitorByMonitorID] (@MonitorID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [im].[MonitorID],
            [im].[UnitOrganizationID],
            [im].[NetworkID],
            [im].[NodeID],
            [im].[BedID],
            [im].[BedCode],
            [im].[Room],
            [im].[MonitorTypeCode],
            [io].[OrganizationCode],
            [im].[MonitorName],
            [io].[OutboundInterval],
            [im].[Subnet]
        FROM
            [Intesys].[Monitor]          AS [im]
            LEFT OUTER JOIN
                [Intesys].[Organization] AS [io]
                    ON [im].[UnitOrganizationID] = [io].[OrganizationID]
        WHERE
            [im].[MonitorID] = @MonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspMonitorLoaderLoadMonitorByMonitorID';

