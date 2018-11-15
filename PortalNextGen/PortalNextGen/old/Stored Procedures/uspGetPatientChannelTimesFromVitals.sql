CREATE PROCEDURE [old].[uspGetPatientChannelTimesFromVitals] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([ir].[ResultDateTime]) AS [MIN_STARTDateTime],
            MAX([ir].[ResultDateTime]) AS [MAX_ENDDateTime],
            [ict].[ChannelCode]        AS [CHANNEL_CODE],
            [ict].[Label]              AS [LABEL],
            [ict].[Priority],
            [ict].[ChannelTypeID]      AS [CHANNEL_TYPEID],
            [ict].[Frequency]          AS [SampleRate]
        FROM
            [Intesys].[Result]             AS [ir]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [ir].[PatientID] = [ipc].[PatientID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        GROUP BY
            [ir].[PatientID],
            [ict].[ChannelCode],
            [ict].[Label],
            [ict].[Priority],
            [ict].[ChannelTypeID],
            [ict].[Frequency]
        HAVING
            [ir].[PatientID] = @PatientID
        UNION ALL
        SELECT
            MIN([vd].[Timestamp]) AS [MinStartDateTime],
            MAX([vd].[Timestamp]) AS [MaxEndDateTime],
            [tft].[ChannelCode]      AS [CHANNEL_CODE],
            [ict].[Label]            AS [LABEL],
            [ict].[Priority],
            [tft].[FeedTypeID]       AS [CHANNEL_TYPEID],
            [tft].[SampleRate]       AS [SampleRate]
        FROM
            [old].[Vital]                 AS [vd]
            INNER JOIN
                [old].[TopicSession]           AS [ts]
                    ON [ts].[TopicSessionID] = [vd].[TopicSessionID]
            INNER JOIN
                [old].[FeedType]         AS [tft]
                    ON [tft].[TopicTypeID] = [ts].[TopicTypeID]
            INNER JOIN
                [Intesys].[ChannelType]        AS [ict]
                    ON [ict].[ChannelCode] = [tft].[ChannelCode]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [vpts].[TopicSessionID] = [ts].[TopicSessionID]
        WHERE
            [vpts].[PatientID] = @PatientID
            AND [tft].[SampleRate] IS NOT NULL
        GROUP BY
            [tft].[FeedTypeID],
            [tft].[ChannelCode],
            [ict].[Label],
            [tft].[SampleRate],
            [ict].[Priority]
        ORDER BY
            [ict].[Priority];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get the patient channel start and end times from vitals.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientChannelTimesFromVitals';

