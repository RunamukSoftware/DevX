CREATE TABLE [dbo].[int_event_config] (
    [alarm_notification_mode]       INT     NOT NULL,
    [vitals_update_interval]        INT     NOT NULL,
    [alarm_polling_interval]        INT     NOT NULL,
    [port_number]                   INT     NOT NULL,
    [track_alarm_execution]         TINYINT NULL,
    [track_vitals_update_execution] TINYINT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the information about configuration of alarm handling events.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alarm mode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'alarm_notification_mode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Interval (min.) of updating', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'vitals_update_interval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Interval (min.) of polling information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'alarm_polling_interval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Port number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'port_number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag: 1 = alarm execution', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'track_alarm_execution';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag: 1 = update vital  signs', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_event_config', @level2type = N'COLUMN', @level2name = N'track_vitals_update_execution';

