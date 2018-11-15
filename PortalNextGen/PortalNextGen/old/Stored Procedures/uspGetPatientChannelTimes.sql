CREATE PROCEDURE [old].[uspGetPatientChannelTimes] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            MIN([iw].[StartDateTime]) AS [MinimumStartDateTime],
            MAX([iw].[EndDateTime])   AS [MaximumEndDateTime],
            [ict].[ChannelCode],
            NULL                      AS [Label],
            [ict].[Priority],
            [ict].[ChannelTypeID],
            [ict].[Frequency]         AS [SampleRate]
        FROM
            [Intesys].[Waveform]           AS [iw]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [iw].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ipc].[PatientID] = @PatientID
        GROUP BY
            [ict].[ChannelCode],
            [ict].[Label],
            [ict].[Priority],
            [ict].[ChannelTypeID],
            [ict].[Frequency]
        UNION ALL
        SELECT
            MIN([wd].[StartDateTime]) AS [MinimumStartDateTime],
            MAX([wd].[EndDateTime])   AS [MaximumEndDateTime],
            [tft].[ChannelCode],
            NULL                      AS [Label],
            [ict].[Priority],
            [wd].[TypeID],
            [tft].[SampleRate]
        FROM
            [old].[Waveform]                   AS [wd]
            INNER JOIN
                [old].[vwPatientTopicSessions] AS [vpts]
                    ON [wd].[TopicSessionID] = [vpts].[TopicSessionID]
                       AND [vpts].[PatientID] = @PatientID
            INNER JOIN
                [old].[FeedType]         AS [tft]
                    ON [tft].[FeedTypeID] = [wd].[TypeID]
            LEFT OUTER JOIN
                [Intesys].[ChannelType]        AS [ict]
                    ON [ict].[ChannelCode] = [tft].[ChannelCode]
        GROUP BY
            [tft].[ChannelCode],
            [wd].[TypeID],
            [tft].[SampleRate],
            [ict].[Priority]
        ORDER BY
            [ict].[Priority];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get patient channel times.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientChannelTimes';

