CREATE TABLE [dbo].[int_event_log] (
    [event_id]    UNIQUEIDENTIFIER NOT NULL,
    [patient_id]  UNIQUEIDENTIFIER NULL,
    [type]        NVARCHAR (30)    NULL,
    [event_dt]    DATETIME         NULL,
    [seq_num]     INT              NOT NULL,
    [client]      NVARCHAR (50)    NULL,
    [description] NVARCHAR (300)   NULL,
    [status]      INT              NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores information about events.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event Id.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'event_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of the event', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'event_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequential number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'seq_num';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'client';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description of the event', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_log', @level2type = N'COLUMN', @level2name = N'status';

