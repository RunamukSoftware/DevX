CREATE PROCEDURE [CEI].[uspGetSettings]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [iec].[TrackAlarmExecution],
            [iec].[TrackVitalsUpdateExecution],
            [iec].[AlarmNotificationMode],
            [iec].[VitalsUpdateInterval],
            [iec].[PortNumber],
            [iec].[AlarmPollingInterval]
        FROM
            [Intesys].[EventConfiguration] AS [iec];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetSettings';

