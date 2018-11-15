CREATE PROCEDURE [old].[uspGetVsvAccess] (@PatientMonitorID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            1
        FROM
            [Intesys].[PatientMonitor]    AS [PM]
            INNER JOIN
                [Intesys].[Monitor]       AS [M]
                    ON [M].[MonitorID] = [PM].[MonitorID]
                       AND [PM].[PatientMonitorID] = @PatientMonitorID
            INNER JOIN
                [Intesys].[ProductAccess] AS [PA]
                    ON [PA].[OrganizationID] = [M].[UnitOrganizationID]
                       AND [PA].[ProductCode] = 'vsv';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetVsvAccess';

