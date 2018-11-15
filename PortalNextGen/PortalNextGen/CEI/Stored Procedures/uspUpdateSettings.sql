CREATE PROCEDURE [CEI].[uspUpdateSettings]
    (
        @alarmNotificationMode      INT     = NULL,
        @vitalsUpdateInterval       INT     = NULL,
        @portNumber                 INT     = NULL,
        @trackAlarmExecution        TINYINT = NULL,
        @trackVitalsUpdateExecution TINYINT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[EventConfiguration]
        SET
            [AlarmNotificationMode] = ISNULL(@alarmNotificationMode, [AlarmNotificationMode]),
            [VitalsUpdateInterval] = ISNULL(@vitalsUpdateInterval, [VitalsUpdateInterval]),
            [PortNumber] = ISNULL(@portNumber, [PortNumber]),
            [TrackAlarmExecution] = ISNULL(@trackAlarmExecution, [TrackAlarmExecution]),
            [TrackVitalsUpdateExecution] = ISNULL(@trackVitalsUpdateExecution, [TrackVitalsUpdateExecution]);

    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspUpdateSettings';

