CREATE PROCEDURE [dbo].[usp_CEI_GetAlarmWaveform]
    (
     @PatientId UNIQUEIDENTIFIER,
     @channeltypeId UNIQUEIDENTIFIER,
     @StartDateTimeUTC DATETIME,
     @EndDateTimeUTC DATETIME
    )
AS
BEGIN
    SELECT
        [StartTimeUTC] AS [START_DT_UTC],
        [EndTimeUTC] AS [END_DT_UTC],
        [Samples] AS [WAVEFORM_DATA]
    FROM
        [dbo].[WaveformLiveData]
    WHERE
        [WaveformLiveData].[TopicInstanceId] IN (SELECT
                                                    [TopicInstanceId]
                                                 FROM
                                                    [dbo].[v_PatientTopicSessions]
                                                    INNER JOIN [dbo].[TopicSessions] ON [TopicSessions].[Id] = [TopicSessionId]
                                                 WHERE
                                                    [PatientId] = @PatientId)
        AND [WaveformLiveData].[TypeId] = @channeltypeId
        AND [StartTimeUTC] <= @EndDateTimeUTC
        AND @StartDateTimeUTC <= [EndTimeUTC]
    ORDER BY
        [StartTimeUTC] ASC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the waveforms for the Alarm in CEI.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CEI_GetAlarmWaveform';

