CREATE PROCEDURE [old].[uspGetEnhancedTelemetryStatusEvents] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ed].[Subtype],
            [ed].[Value1],
            [ed].[Status],
            [ed].[ValidLeads],
            [ed].[Timestamp],
            [ts].[EndDateTime]
        FROM
            [old].[Event]                      AS [ed]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [ed].[TopicSessionID]
            INNER JOIN
                [old].[TopicSession]           AS [ts]
                    ON [ts].[TopicSessionID] = [ed].[TopicSessionID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [ed].[CategoryValue] = 2
            AND [ed].[Type] = 1
        ORDER BY
            [ts].[EndDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Enhanced Telemetry (ET) status events.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryStatusEvents';

