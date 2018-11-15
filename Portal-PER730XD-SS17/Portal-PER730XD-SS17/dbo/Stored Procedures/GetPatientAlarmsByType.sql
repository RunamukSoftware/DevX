CREATE PROCEDURE [dbo].[GetPatientAlarmsByType]
    (
     @patient_id UNIQUEIDENTIFIER,
     @alarm_type INT,
     @start_ft BIGINT,
     @end_ft BIGINT
    )
AS
BEGIN
    SELECT
        [alarm_id] AS [ID],
        [alarm_cd] AS [TITLE],
        [start_ft] AS [start_ft],
        [end_ft] AS [end_ft],
        [start_dt] AS [START_DT],
        [removed],
        [alarm_level] AS [priority]
    FROM
        [dbo].[int_alarm]
        INNER JOIN [dbo].[int_patient_channel] ON [int_alarm].[patient_channel_id] = [int_patient_channel].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] ON [int_patient_channel].[channel_type_id] = [int_channel_type].[channel_type_id]
    WHERE
        [int_alarm].[patient_id] = @patient_id
        AND [int_channel_type].[channel_code] = @alarm_type
        AND ((@start_ft < [int_alarm].[end_ft]
        AND @end_ft >= [int_alarm].[start_ft]
        )
        OR (@end_ft >= [int_alarm].[start_ft]
        AND [int_alarm].[end_ft] IS NULL
        )
        )
    ORDER BY
        [start_ft];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetPatientAlarmsByType';

