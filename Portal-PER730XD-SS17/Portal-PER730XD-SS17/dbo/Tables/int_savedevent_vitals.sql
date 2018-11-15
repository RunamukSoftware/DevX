CREATE TABLE [dbo].[int_savedevent_vitals] (
    [patient_id]   UNIQUEIDENTIFIER NOT NULL,
    [event_id]     UNIQUEIDENTIFIER NOT NULL,
    [gds_code]     NVARCHAR (80)    NOT NULL,
    [result_dt]    DATETIME         NULL,
    [result_value] NVARCHAR (200)   NULL,
    CONSTRAINT [PK_int_savedevent_vitals_patient_id_event_id_gds_code] PRIMARY KEY CLUSTERED ([patient_id] ASC, [event_id] ASC, [gds_code] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_int_savedevent_vitals_int_savedevent_patient_id_event_id] FOREIGN KEY ([patient_id], [event_id]) REFERENCES [dbo].[int_SavedEvent] ([patient_id], [event_id]) ON DELETE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_savedevent_vitals';

