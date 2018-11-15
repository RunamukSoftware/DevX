CREATE PROCEDURE [dbo].[UpdatePatientSavedEvent]
    (
     @patient_id UNIQUEIDENTIFIER,
     @event_id UNIQUEIDENTIFIER,
     @title DTITLE,
     @comment DCOMMENT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_SavedEvent]
    SET
        [title] = @title,
        [comment] = @comment
    WHERE
        [patient_id] = @patient_id
        AND [event_id] = @event_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'UpdatePatientSavedEvent';

