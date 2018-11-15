CREATE TABLE [dbo].[int_alarm] (
    [alarm_id]           UNIQUEIDENTIFIER NOT NULL,
    [patient_id]         UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]    UNIQUEIDENTIFIER NULL,
    [patient_channel_id] UNIQUEIDENTIFIER NOT NULL,
    [start_dt]           DATETIME         NOT NULL,
    [end_dt]             DATETIME         NULL,
    [start_ft]           BIGINT           NULL,
    [end_ft]             BIGINT           NULL,
    [alarm_cd]           NVARCHAR (50)    NULL,
    [alarm_dsc]          NVARCHAR (255)   NULL,
    [removed]            TINYINT          NULL,
    [alarm_level]        TINYINT          NULL,
    [is_stacked]         VARCHAR (1)      NULL,
    [is_level_changed]   VARCHAR (1)      NULL,
    CONSTRAINT [PK_int_alarm_alarm_id_patient_id_patient_channel_id] PRIMARY KEY NONCLUSTERED ([alarm_id] ASC, [patient_id] ASC, [patient_channel_id] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE CLUSTERED INDEX [CL_int_alarm_patient_id_start_ft_end_ft_alarm_level]
    ON [dbo].[int_alarm]([patient_id] ASC, [start_ft] ASC, [end_ft] ASC, [alarm_level] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_alarm_patient_channel_id_start_dt]
    ON [dbo].[int_alarm]([patient_channel_id] ASC, [start_dt] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores alarm events collected from the monitor. Each record is uniquely identified by alarm_id. The data in this table is populated by the MonitorLoader process.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying an alarm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'alarm_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID indentifying a patient. Foreign key to the int_patient table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Original patient Id.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID identifying a channel type. Foreign key to the int_channel_type table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'patient_channel_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The start time of the alarm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'start_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end date of the alarm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'end_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The bigint representation of the utc start time of the alarm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'start_ft';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The bigint representation of the utc end date of the alarm.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'end_ft';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A text value representing the alarm Subtype (ie Vfib).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'alarm_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The alarm annotation text.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'alarm_dsc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alarm severity level', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'alarm_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates if alarm type has changed during it''s lifetime', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'is_stacked';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates if alarm level has changed during it''s lifetime', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_alarm', @level2type = N'COLUMN', @level2name = N'is_level_changed';

