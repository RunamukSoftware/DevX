CREATE PROCEDURE [dbo].[SaveEvent]
    @patient_id UNIQUEIDENTIFIER,
    @user_id UNIQUEIDENTIFIER,
    @event_id UNIQUEIDENTIFIER,
    @insert_dt DATETIME,
    @orig_event_category INT,
    @start_dt DATETIME,
    @start_ms BIGINT,
    @duration INT,
    @print_format INT,
    @title DTITLE,
    @comment DCOMMENT,
    @annotate_data TINYINT,
    @beat_color TINYINT,
    @num_waveforms INT,
    @sweep_speed INT,
    @minutes_per_page INT,
    @thumbnailChannel INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT  INTO [dbo].[int_SavedEvent]
            ([patient_id],
             [event_id],
             [insert_dt],
             [user_id],
             [orig_event_category],
             [orig_event_type],
             [start_dt],
             [start_ms],
             [duration],
             [value1],
             [value2],
             [print_format],
             [title],
             [comment],
             [annotate_data],
             [beat_color],
             [num_waveforms],
             [sweep_speed],
             [minutes_per_page],
             [thumbnailChannel]
            )
    VALUES
            (@patient_id,
             @event_id,
             @insert_dt,
             @user_id,
             @orig_event_category,
             -1, -- Event Type
             @start_dt,
             @start_ms,
             @duration,
             0, -- [value1] [int] NOT NULL,
             0, -- [value2] INT NULL,
             @print_format,
             @title,
             @comment,
             @annotate_data,
             @beat_color,
             @num_waveforms,
             @sweep_speed,
             @minutes_per_page,
             @thumbnailChannel
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'SaveEvent';

