CREATE VIEW [old].[vwLegacyWaveform]
WITH SCHEMABINDING
AS
    SELECT
        [w].[WaveformID],
        [w].[SampleCount],
        [vwsr].[TypeName],
        [w].[TypeID],
        [w].[Samples]        AS [WaveformData],
        [ts].[TopicTypeID],
        [w].[TopicSessionID],
        [ts].[DeviceSessionID],
        [ts].[BeginDateTime] AS [SessionBegin],
        [w].[StartDateTime],
        [w].[EndDateTime],
        [vwsr].[SampleRate],
        [vpts].[PatientID],
        [ts].[TopicInstanceID],
        CASE
            WHEN [w].[Compressed] = 0
                THEN NULL
            ELSE
                'WCTZLIB'
        END                  AS [CompressMethod]
    FROM
        [old].[Waveform]                   AS [w]
        INNER JOIN
            [old].[vwWaveformSampleRate]   AS [vwsr]
                ON [vwsr].[FeedTypeID] = [w].[TypeID]
        INNER JOIN
            [old].[TopicSession]           AS [ts]
                ON [ts].[TopicSessionID] = [w].[TopicSessionID]
        INNER JOIN
            [old].[vwPatientTopicSessions] AS [vpts]
                ON [vpts].[TopicSessionID] = [ts].[TopicSessionID];
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<View description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'VIEW', @level1name = N'vwLegacyWaveform';

