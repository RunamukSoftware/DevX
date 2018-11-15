CREATE PROCEDURE [old].[uspGetEnhancedTelemetryTechnicalAlarms]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [EndAlarmPackets].[IDEnumValue]   AS [ALARM_TYPE],
            [EndAlarmPackets].[StartDateTime] AS [FT_START],
            [EndAlarmPackets].[EndDateTime]   AS [FT_END]
        FROM
            (
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY
                                           [gad].[GeneralAlarmID]
                                       ORDER BY
                                           [gad].[AcquiredDateTime] DESC
                                      ) AS [RowNumber],
                    [gad].[StartDateTime],
                    [gad].[EndDateTime],
                    [gad].[IDEnumValue],
                    [gad].[TopicSessionID]
                FROM
                    [old].[GeneralAlarm] AS [gad]
                WHERE
                    [gad].[TopicSessionID] IN (
                                                  SELECT
                                                      [vpts].[TopicSessionID]
                                                  FROM
                                                      [old].[vwPatientTopicSessions] AS [vpts]
                                                  WHERE
                                                      [vpts].[PatientID] = @PatientID
                                              )
                    AND [gad].[IDEnumValue] IN (
                                                   105, 102, 204
                                               ) -- 105 is signal loss, 102 is interference, 204 is ElectrodeOff_LL
                    AND (
                            [gad].[EndDateTime] >= @StartDateTime
                            AND [gad].[EndDateTime] <= @EndDateTime
                            OR [gad].[StartDateTime] >= @StartDateTime
                               AND [gad].[StartDateTime] <= @EndDateTime
                        )
            ) AS [EndAlarmPackets]
        WHERE
            [EndAlarmPackets].[RowNumber] = 1
        ORDER BY
            [EndAlarmPackets].[IDEnumValue],
            [EndAlarmPackets].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Enhanced Telemetry (ET) technical alarms.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryTechnicalAlarms';

