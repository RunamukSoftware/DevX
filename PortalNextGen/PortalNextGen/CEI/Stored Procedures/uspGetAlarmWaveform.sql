CREATE PROCEDURE [CEI].[uspGetAlarmWaveform]
    (
        @PatientID     INT,
        @ChannelTypeID INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [wl].[StartDateTime],
            [wl].[EndDateTime],
            [wl].[Samples] AS [WaveformData]
        FROM
            [old].[WaveformLive] AS [wl]
        WHERE
            [wl].[TopicInstanceID] IN (
                                          SELECT
                                              [ts].[TopicInstanceID]
                                          FROM
                                              [old].[vwPatientTopicSessions] AS [vpts]
                                              INNER JOIN
                                                  [old].[TopicSession]       AS [ts]
                                                      ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
                                          WHERE
                                              [vpts].[PatientID] = @PatientID
                                      )
            AND [wl].[TypeID] = @ChannelTypeID
            AND [wl].[StartDateTime] <= @EndDateTime
            AND @StartDateTime <= [wl].[EndDateTime]
        ORDER BY
            [wl].[StartDateTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the waveforms for the Alarm in CEI.', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetAlarmWaveform';

