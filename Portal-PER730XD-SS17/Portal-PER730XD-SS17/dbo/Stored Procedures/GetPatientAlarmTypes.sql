CREATE PROCEDURE [dbo].[GetPatientAlarmTypes]
    (
     @patient_id UNIQUEIDENTIFIER,
     @start_ft BIGINT,
     @end_ft BIGINT
    )
AS
BEGIN
    DECLARE 
        @start_dt DATETIME = [dbo].[fnFileTimeToDateTime](@start_ft),
        @end_dt DATETIME = [dbo].[fnFileTimeToDateTime](@end_ft)

    SELECT DISTINCT
        [int_channel_type].[channel_code] AS [TYPE],
        [int_alarm].[alarm_cd] AS [TITLE]
    FROM
        [dbo].[int_alarm]
        INNER JOIN [dbo].[int_patient_channel] ON [int_alarm].[patient_channel_id] = [int_patient_channel].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] ON [int_patient_channel].[channel_type_id] = [int_channel_type].[channel_type_id]
    WHERE
        [int_alarm].[patient_id] = @patient_id
        AND [int_alarm].[alarm_level] > 0
        AND ((@start_ft < [int_alarm].[end_ft]
        AND @end_ft >= [int_alarm].[start_ft]
        )
        OR (@end_ft >= [int_alarm].[start_ft]
        AND [int_alarm].[end_ft] IS NULL
        )
        )
    UNION ALL
    SELECT
        [ChannelCode] AS [TYPE],
        [Title] AS [TITLE]
    FROM
        [dbo].[v_GeneralAlarms]
    WHERE
        [AlarmId] IN (SELECT
                        [AlarmId]
                      FROM
                        [dbo].[GeneralAlarmsData]
                      WHERE
                        [TopicSessionId] IN (SELECT
                                                [TopicSessionId]
                                             FROM
                                                [dbo].[v_PatientTopicSessions]
                                             WHERE
                                                [PatientId] = @patient_id)
                        AND ((@start_dt < [EndDateTime]
                        AND @end_dt >= [StartDateTime]
                        )
                        OR (@end_dt >= [StartDateTime]
                        AND [EndDateTime] IS NULL
                        )
                        )
                        AND [PriorityWeightValue] > 0)
    UNION ALL
    SELECT
        [ChannelCode] AS [TYPE],
        [AlarmType] AS [TITLE]
    FROM
        [dbo].[v_LimitAlarms]
    WHERE
        [AlarmId] IN (SELECT
                        [AlarmId]
                      FROM
                        [dbo].[LimitAlarmsData]
                      WHERE
                        [TopicSessionId] IN (SELECT
                                                [TopicSessionId]
                                             FROM
                                                [dbo].[v_PatientTopicSessions]
                                             WHERE
                                                [PatientId] = @patient_id)
                        AND ((@start_dt < [EndDateTime]
                        AND @end_dt >= [StartDateTime]
                        )
                        OR (@end_dt >= [StartDateTime]
                        AND [EndDateTime] IS NULL
                        )
                        )
                        AND [PriorityWeightValue] > 0);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientAlarmTypes';

