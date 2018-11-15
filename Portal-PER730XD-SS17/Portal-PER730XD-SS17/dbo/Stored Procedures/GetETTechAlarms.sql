CREATE PROCEDURE [dbo].[GetETTechAlarms]
    (
     @PatientId UNIQUEIDENTIFIER,
     @StartTime BIGINT,
     @EndTime BIGINT
    )
AS
BEGIN
    DECLARE @end_dt DATETIME = [dbo].[fnFileTimeToDateTime](@EndTime);
    DECLARE @start_dt DATETIME = [dbo].[fnFileTimeToDateTime](@StartTime);

    SELECT
        [EndAlarmPackets].[IDEnumValue] AS [ALARM_TYPE],
        --[dbo].[fnDateTimeToFileTime]([EndAlarmPackets].[StartDateTime]) AS [FT_START],
        --[dbo].[fnDateTimeToFileTime]([EndAlarmPackets].[EndDateTime]) AS [FT_END]
        [FT_START].[FileTime] AS [FT_START],
        [FT_END].[FileTime] AS [FT_END]
    FROM
        (SELECT
            ROW_NUMBER() OVER (PARTITION BY [gad].[AlarmId] ORDER BY [gad].[AcquiredDateTimeUTC] DESC) AS [RowNumber],
            [gad].[StartDateTime],
            [gad].[EndDateTime],
            [gad].[IDEnumValue],
            [gad].[TopicSessionId]
         FROM
            [dbo].[GeneralAlarmsData] AS [gad]
         WHERE
            [gad].[TopicSessionId] IN (SELECT
                                        [vpts].[TopicSessionId]
                                       FROM
                                        [dbo].[v_PatientTopicSessions] AS [vpts]
                                       WHERE
                                        [vpts].[PatientId] = @PatientId)
            AND [gad].[IDEnumValue] IN (105, 102, 204) -- 105 is signal loss, 102 is interference, 204 is ElectrodeOff_LL
            AND ([gad].[EndDateTime] >= @start_dt
                 AND [gad].[EndDateTime] <= @end_dt
                 OR [gad].[StartDateTime] >= @start_dt
                 AND [gad].[StartDateTime] <= @end_dt)
        ) AS [EndAlarmPackets]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([EndAlarmPackets].[StartDateTime]) AS [FT_START]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([EndAlarmPackets].[EndDateTime]) AS [FT_END]
    WHERE
        [EndAlarmPackets].[RowNumber] = 1
    ORDER BY
        [EndAlarmPackets].[IDEnumValue],
        [EndAlarmPackets].[StartDateTime];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get ET tech alarms.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetETTechAlarms';

