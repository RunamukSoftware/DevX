CREATE PROCEDURE [dbo].[SaveArrhythmiaEventTime]
    (
     @patient_id [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @event_id AS UNIQUEIDENTIFIER,
     @timetag_type AS INT,
     @arrhythmia_event_type AS INT,
     @start_ms AS BIGINT,
     @end_ms AS BIGINT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_savedevent_event_log]
            ([patient_id],
             [event_id],
             [timetag_type],
             [arrhythmia_event_type],
             [start_ms],
             [end_ms]
            )
    VALUES
            (CAST(@patient_id AS UNIQUEIDENTIFIER),
             @event_id,
             @timetag_type,
             @arrhythmia_event_type,
             @start_ms,
             @end_ms
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveArrhythmiaEventTime';

