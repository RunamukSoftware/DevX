CREATE PROCEDURE [dbo].[GetLegacyPatientAlarms]
    (
     @patient_id UNIQUEIDENTIFIER,
     @start_ft BIGINT,
     @end_ft BIGINT,
     @locale VARCHAR(7) = 'en'
    )
AS
BEGIN
    SELECT
        [Id] = [alarm_id],
        [TYPE] = [int_channel_type].[channel_code],
        [TypeString] = ISNULL([alarm_cd], ''),
        [TITLE] = ISNULL([alarm_cd], ''),
        [start_ft] = [start_ft],
        [end_ft] = [end_ft],
        [START_DT] = [start_dt],
        [Removed] = [removed],
        [priority] = [alarm_level],
        [Label] = CAST('' AS NVARCHAR(250))
    FROM
        [dbo].[int_alarm]
        INNER JOIN [dbo].[int_patient_channel] ON [int_alarm].[patient_channel_id] = [int_patient_channel].[patient_channel_id]
        INNER JOIN [dbo].[int_channel_type] ON [int_patient_channel].[channel_type_id] = [int_channel_type].[channel_type_id]
    WHERE
        [int_alarm].[patient_id] = @patient_id
        AND [alarm_level] > 0
        AND (@start_ft < [int_alarm].[end_ft]
        OR [int_alarm].[end_ft] IS NULL
        )
    ORDER BY
        [start_ft] DESC;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get a list of alarms from a non enhanced tele patient', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLegacyPatientAlarms';

