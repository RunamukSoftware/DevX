CREATE PROCEDURE [dbo].[GetETBeatTimeLog]
    (
     @patient_id UNIQUEIDENTIFIER,
     @StartFileTimeUTC BIGINT = NULL, -- Default to allow for return of all the data
     @EndFileTimeUTC BIGINT = NULL -- Default to allow for return of all the data
    )
AS
BEGIN
     DECLARE
        @StartTimeUTC DATETIME = NULL,
        @EndTimeUTC DATETIME = NULL;
 
     IF (@StartFileTimeUTC IS NULL)
     BEGIN
        SET @StartFileTimeUTC = [dbo].[fnDateTimeToFileTime]('2000-01-01T00:00:00.000'); -- Default to allow for return of all the data
     END;
 
     IF (@EndFileTimeUTC IS NULL)
     BEGIN
        SET @EndFileTimeUTC = [dbo].[fnDateTimeToFileTime]('2035-12-31T23:59:59.998'); -- Default to allow for return of all the data - any larger will overflow INT.
     END;
 
     SELECT
        @StartTimeUTC = [dbo].[fnFileTimeToDateTime](@StartFileTimeUTC),
        @EndTimeUTC = [dbo].[fnFileTimeToDateTime](@EndFileTimeUTC);
 
    SELECT
        [ed].[Type] AS [TYPE],
        [ed].[Subtype] AS [Subtype],
        [ed].[Value1] AS [VALUE1],
        [ed].[Value2] AS [VALUE2],
        [ed].[Status] AS [STATUS_VALUE],
        [ed].[Valid_Leads] AS [LEADS],
        [TimestampUTCFileTime].[FileTime] AS [FT_TIME]
    FROM
        [dbo].[EventsData] AS [ed]
        INNER JOIN [dbo].[v_PatientTopicSessions] AS [vpts]
            ON [vpts].[TopicSessionId] = [ed].[TopicSessionId]
        CROSS APPLY [dbo].[fntDateTimeToFileTime]([ed].[TimestampUTC]) AS [TimestampUTCFileTime]
    WHERE
        [vpts].[PatientId] = @patient_id
        AND [ed].[CategoryValue] = 0
        AND [ed].[TimestampUTC] BETWEEN @StartTimeUTC AND @EndTimeUTC
    ORDER BY
        [ed].[TimestampUTC];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the ET beat time log for the specified patient for a specified amount of time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetETBeatTimeLog';

