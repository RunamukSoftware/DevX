CREATE TABLE [dbo].[int_patient_monitor] (
    [patient_monitor_id]  UNIQUEIDENTIFIER NOT NULL,
    [patient_id]          UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]     UNIQUEIDENTIFIER NULL,
    [monitor_id]          UNIQUEIDENTIFIER NOT NULL,
    [monitor_interval]    INT              NULL,
    [poll_type]           CHAR (1)         NOT NULL,
    [monitor_connect_dt]  DATETIME         NULL,
    [monitor_connect_num] INT              NULL,
    [disable_sw]          TINYINT          NULL,
    [last_poll_dt]        DATETIME         NULL,
    [last_result_dt]      DATETIME         NULL,
    [last_episodic_dt]    DATETIME         NULL,
    [poll_start_dt]       DATETIME         NULL,
    [poll_end_dt]         DATETIME         NULL,
    [last_outbound_dt]    DATETIME         NULL,
    [monitor_status]      CHAR (3)         NULL,
    [monitor_error]       NVARCHAR (255)   NULL,
    [encounter_id]        UNIQUEIDENTIFIER NULL,
    [live_until_dt]       DATETIME         NULL,
    [active_sw]           TINYINT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_monitor_patient_id_monitor_id_monitor_connect_dt]
    ON [dbo].[int_patient_monitor]([patient_id] ASC, [monitor_id] ASC, [monitor_connect_dt] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_patient_monitor_monitor_id]
    ON [dbo].[int_patient_monitor]([monitor_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is the key table that tracks what patients are currently connected to monitors. It maintains records ONLY for patients that the gateways believe to be on monitor. It does NOT maintain history of who was connected (that is in the int_encounter table). As the monitor loaders communicate to the monitors through the gateways, this table is kept 100% current with the real-world. Patients are created/updated as necessary. And encounters are created/updated as necessary. Purging this table should have no real consequences because the data will be rebuilt by the loaders (with the exception of any manually overriden collection intervals).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_monitor';

