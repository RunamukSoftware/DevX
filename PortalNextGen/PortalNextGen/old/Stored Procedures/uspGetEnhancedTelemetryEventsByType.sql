CREATE PROCEDURE [old].[uspGetEnhancedTelemetryEventsByType]
    (
        @PatientID     INT,
        @Category      INT,
        @Type          INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [ed].[Value1]    AS [VALUE1],
            [ed].[Value2]    AS [VALUE2],
            [ed].[Status]    AS [STATUS_VALUE],
            [ed].[Timestamp] AS [FT_TIME]
        FROM
            [old].[Event]                      AS [ed]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [ed].[TopicSessionID] = [vpts].[TopicSessionID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [ed].[CategoryValue] = @Category
            AND [ed].[Type] = @Type
            AND [ed].[Timestamp] >= @StartDateTime
            AND [ed].[Timestamp] <= @EndDateTime
        ORDER BY
            [FT_TIME];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the ETR events by category and Type for a specified date (file time) range.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryEventsByType';

