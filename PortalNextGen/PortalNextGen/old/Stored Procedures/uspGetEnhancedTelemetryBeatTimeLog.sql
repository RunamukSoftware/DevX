CREATE PROCEDURE [old].[uspGetEnhancedTelemetryBeatTimeLog]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7) = NULL, -- Default to allow for return of all the data
        @EndDateTime   DATETIME2(7) = NULL  -- Default to allow for return of all the data
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@StartDateTime IS NULL)
            BEGIN
                SET @StartDateTime = CAST('2000-01-01T00:00:00.000' AS DATETIME2(7)); -- Default to allow for return of all the data
            END;

        IF (@EndDateTime IS NULL)
            BEGIN
                SET @EndDateTime = CAST('2035-12-31T23:59:59.998' AS DATETIME2(7)); -- Default to allow for return of all the data - any larger will overflow INT.
            END;

        SELECT
            [ed].[Type],
            [ed].[Subtype],
            [ed].[Value1],
            [ed].[Value2],
            [ed].[Status],
            [ed].[ValidLeads],
            [ed].[Timestamp]
        FROM
            [old].[Event]                      AS [ed]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [ed].[TopicSessionID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [ed].[CategoryValue] = 0
            AND [ed].[Timestamp]
            BETWEEN @StartDateTime AND @EndDateTime
        ORDER BY
            [ed].[Timestamp];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the Enhanced Telemetry (ET) beat time log for the specified patient for a specified amount of time.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryBeatTimeLog';

