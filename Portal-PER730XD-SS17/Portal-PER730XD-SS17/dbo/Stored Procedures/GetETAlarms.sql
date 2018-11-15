CREATE PROCEDURE [dbo].[GetETAlarms]
    (
     @PatientId UNIQUEIDENTIFIER,
     @AlarmType BIGINT,
     @StartTime BIGINT,
     @EndTime BIGINT
    )
AS
BEGIN
    DECLARE
        @end_dt DATETIME = [dbo].[fnFileTimeToDateTime](@EndTime),
        @start_dt DATETIME = [dbo].[fnFileTimeToDateTime](@StartTime);

    SELECT
        [gad].[IDEnumValue] AS [TYPE],
        [FT_START].[FileTime] AS [FT_START],
        [FT_END].[FileTime] AS [FT_END]
    FROM
        [dbo].[GeneralAlarmsData] AS [gad]
        INNER JOIN [dbo].[v_PatientTopicSessions] AS [vpts]
            ON [vpts].[TopicSessionId] = [gad].[TopicSessionId]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([gad].[StartDateTime]) AS [FT_START]
    CROSS APPLY [dbo].[fntDateTimeToFileTime]([gad].[EndDateTime]) AS [FT_END]
    WHERE
        [vpts].[PatientId] = @PatientId
        AND [gad].[IDEnumValue] = @AlarmType
        AND ([gad].[EndDateTime] >= @start_dt
             AND [gad].[EndDateTime] <= @end_dt
             OR [gad].[StartDateTime] >= @start_dt
             AND [gad].[StartDateTime] <= @end_dt)
        AND [gad].[EnumGroupId] = CAST('F6DE38B7-B737-AE89-7486-CF67C64ECF3F' AS UNIQUEIDENTIFIER)
    ORDER BY
        [gad].[StartDateTime];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get ET alarms.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetETAlarms';

