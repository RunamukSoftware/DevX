CREATE TABLE [dbo].[int_SavedEvent] (
    [patient_id]          UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]     UNIQUEIDENTIFIER NULL,
    [event_id]            UNIQUEIDENTIFIER NOT NULL,
    [insert_dt]           DATETIME         NOT NULL,
    [user_id]             UNIQUEIDENTIFIER NOT NULL,
    [orig_event_category] INT              NOT NULL,
    [orig_event_type]     INT              NOT NULL,
    [start_dt]            DATETIME         NOT NULL,
    [start_ms]            BIGINT           NOT NULL,
    [center_ft]           BIGINT           NULL,
    [duration]            INT              NOT NULL,
    [value1]              FLOAT (53)       NOT NULL,
    [value2]              FLOAT (53)       NULL,
    [print_format]        INT              NOT NULL,
    [title]               NVARCHAR (50)    NULL,
    [comment]             [dbo].[DCOMMENT] NULL,
    [annotate_data]       TINYINT          NOT NULL,
    [beat_color]          TINYINT          NOT NULL,
    [num_waveforms]       INT              NOT NULL,
    [sweep_speed]         INT              NOT NULL,
    [minutes_per_page]    INT              NOT NULL,
    [thumbnailChannel]    INT              NULL,
    CONSTRAINT [PK_int_savedevent_patient_id_event_id] PRIMARY KEY CLUSTERED ([patient_id] ASC, [event_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains general information about the saved event. It should have patient_id and event_id as PKs. There will be one row for each saved event.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_SavedEvent';

