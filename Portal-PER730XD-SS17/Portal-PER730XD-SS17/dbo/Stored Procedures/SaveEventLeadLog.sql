CREATE PROCEDURE [dbo].[SaveEventLeadLog]
    (
     @patient_id AS UNIQUEIDENTIFIER,
     @event_id AS UNIQUEIDENTIFIER,
     @primary_channel AS BIT,
     @timetag_type AS INT,
     @lead_type AS INT,
     @start_ms AS BIGINT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_savedevent_event_log]
            ([patient_id],
             [event_id],
             [primary_channel],
             [timetag_type],
             [lead_type],
             [start_ms]
            )
    VALUES
            (@patient_id,
             @event_id,
             @primary_channel,
             @timetag_type,
             @lead_type,
             @start_ms
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveEventLeadLog';

