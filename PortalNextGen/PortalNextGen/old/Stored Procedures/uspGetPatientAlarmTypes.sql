CREATE PROCEDURE [old].[uspGetPatientAlarmTypes]
    (
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [ict].[ChannelCode] AS [Type],
            [ia].[AlarmCode]    AS [TITLE]
        FROM
            [Intesys].[Alarm]              AS [ia]
            INNER JOIN
                [Intesys].[PatientChannel] AS [ipc]
                    ON [ia].[PatientChannelID] = [ipc].[PatientChannelID]
            INNER JOIN
                [Intesys].[ChannelType]    AS [ict]
                    ON [ipc].[ChannelTypeID] = [ict].[ChannelTypeID]
        WHERE
            [ia].[PatientID] = @PatientID
            AND [ia].[AlarmLevel] > 0
            AND (
                    (
                        @StartDateTime < [ia].[EndDateTime]
                        AND @EndDateTime >= [ia].[StartDateTime]
                    )
                    OR (
                           @EndDateTime >= [ia].[StartDateTime]
                           AND [ia].[EndDateTime] IS NULL
                       )
                )
        UNION ALL
        SELECT
            [vga].[ChannelCode] AS [Type],
            [vga].[Title]       AS [TITLE]
        FROM
            [old].[vwGeneralAlarms] AS [vga]
        WHERE
            [vga].[GeneralAlarmID] IN (
                                   SELECT
                                       [gad].[GeneralAlarmID]
                                   FROM
                                       [old].[GeneralAlarm] AS [gad]
                                   WHERE
                                       [gad].[TopicSessionID] IN (
                                                                     SELECT
                                                                         [vpts].[TopicSessionID]
                                                                     FROM
                                                                         [old].[vwPatientTopicSessions] AS [vpts]
                                                                     WHERE
                                                                         [vpts].[PatientID] = @PatientID
                                                                 )
                                       AND (
                                               (
                                                   @StartDateTime < [gad].[EndDateTime]
                                                   AND @EndDateTime >= [gad].[StartDateTime]
                                               )
                                               OR (
                                                      @EndDateTime >= [gad].[StartDateTime]
                                                      AND [gad].[EndDateTime] IS NULL
                                                  )
                                           )
                                       AND [gad].[PriorityWeightValue] > 0
                               )
        UNION ALL
        SELECT
            [vla].[ChannelCode] AS [Type],
            [vla].[AlarmType]   AS [TITLE]
        FROM
            [old].[vwLimitAlarms] AS [vla]
        WHERE
            [vla].[LimitAlarmID] IN (
                                        SELECT
                                            [la].[LimitAlarmID]
                                        FROM
                                            [old].[LimitAlarm] AS [la]
                                        WHERE
                                            [la].[TopicSessionID] IN (
                                                                         SELECT
                                                                             [vpts].[TopicSessionID]
                                                                         FROM
                                                                             [old].[vwPatientTopicSessions] AS [vpts]
                                                                         WHERE
                                                                             [vpts].[PatientID] = @PatientID
                                                                     )
                                            AND (
                                                    (
                                                        @StartDateTime < [la].[EndDateTime]
                                                        AND @EndDateTime >= [la].[StartDateTime]
                                                    )
                                                    OR (
                                                           @EndDateTime >= [la].[StartDateTime]
                                                           AND [la].[EndDateTime] IS NULL
                                                       )
                                                )
                                            AND [la].[PriorityWeightValue] > 0
                                    );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientAlarmTypes';

