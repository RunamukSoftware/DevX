CREATE PROCEDURE [dbo].[GetETEventsByType]
    (
     @patient_id UNIQUEIDENTIFIER,
     @Category INT,
     @Type INT,
     @StartTime BIGINT,
     @EndTime BIGINT
    )
AS
BEGIN
    SELECT DISTINCT
        [ed].[Value1] AS [VALUE1],
        [ed].[Value2] AS [VALUE2],
        [ed].[Status] AS [STATUS_VALUE],
        --[dbo].[fnDateTimeToFileTime]([ed].[TimestampUTC]) AS [FT_TIME]
        [FT_TIME].[FileTime] AS [FT_TIME]
    FROM
        [dbo].[EventsData] AS [ed]
        INNER JOIN [dbo].[v_PatientTopicSessions] AS [vpts]
            ON [ed].[TopicSessionId] = [vpts].[TopicSessionId]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([ed].[TimestampUTC]) AS [FT_TIME]
    WHERE
        [vpts].[PatientId] = @patient_id
        AND [ed].[CategoryValue] = @Category
        AND [ed].[Type] = @Type
        --AND [dbo].[fnDateTimeToFileTime]([ed].[TimestampUTC]) >= @StartTime
        --AND [dbo].[fnDateTimeToFileTime]([ed].[TimestampUTC]) <= @EndTime
        AND [FT_TIME].[FileTime] >= @StartTime
        AND [FT_TIME].[FileTime] <= @EndTime
    ORDER BY
        [FT_TIME];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the ETR events by category and type for a specified date (file time) range.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetETEventsByType';

