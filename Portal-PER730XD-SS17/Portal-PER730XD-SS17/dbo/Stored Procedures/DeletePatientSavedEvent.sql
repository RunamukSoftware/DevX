CREATE PROCEDURE [dbo].[DeletePatientSavedEvent]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE
        [ise]
    FROM
        [dbo].[int_SavedEvent] AS [ise]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;

    DELETE
        [isew]
    FROM
        [dbo].[int_savedevent_waveform] AS [isew]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;

    DELETE
        [isebtl]
    FROM
        [dbo].[int_savedevent_beat_time_log] AS [isebtl]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;

    DELETE
        [isec]
    FROM
        [dbo].[int_savedevent_calipers] AS [isec]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;

    DELETE
        [iseel]
    FROM
        [dbo].[int_savedevent_event_log] AS [iseel]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;

    DELETE
        [isev]
    FROM
        [dbo].[int_savedevent_vitals] AS [isev]
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeletePatientSavedEvent';

