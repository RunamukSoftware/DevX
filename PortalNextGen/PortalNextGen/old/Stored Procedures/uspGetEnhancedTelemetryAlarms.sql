CREATE PROCEDURE [old].[uspGetEnhancedTelemetryAlarms]
    (
        @PatientID     INT,
        @AlarmType     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        --DECLARE
        --    @EndDateTime   DATETIME2(7) = [old].[ufnDateTimeToDateTime](@EndDateTime),
        --    @StartDateTime DATETIME2(7) = [old].[ufnDateTimeToDateTime](@StartDateTime);

        SELECT
            [gad].[IDEnumValue] AS [Type],
            [gad].[StartDateTime],
            [gad].[EndDateTime]
        FROM
            [old].[GeneralAlarm]          AS [gad]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [gad].[TopicSessionID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [gad].[IDEnumValue] = @AlarmType
            AND (
                    [gad].[EndDateTime] >= @StartDateTime
                    AND [gad].[EndDateTime] <= @EndDateTime
                    OR [gad].[StartDateTime] >= @StartDateTime
                       AND [gad].[StartDateTime] <= @EndDateTime
                )
            AND [gad].[EnumGroupID] = CAST('F6DE38B7-B737-AE89-7486-CF67C64ECF3F' AS INT)
        ORDER BY
            [gad].[StartDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Enhanced Telemetry (ET) alarms.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryAlarms';

