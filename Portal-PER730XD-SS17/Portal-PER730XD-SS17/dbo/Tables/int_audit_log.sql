CREATE TABLE [dbo].[int_audit_log] (
    [login_id]        NVARCHAR (256)   NULL,
    [application_id]  NVARCHAR (50)    NULL,
    [patient_id]      NVARCHAR (50)    NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [audit_type]      NVARCHAR (160)   NULL,
    [device_name]     NVARCHAR (64)    NULL,
    [audit_descr]     NVARCHAR (500)   NULL,
    [audit_dt]        DATETIME         NOT NULL,
    [encounter_id]    UNIQUEIDENTIFIER NULL,
    [detail_id]       UNIQUEIDENTIFIER NULL
);


GO
CREATE CLUSTERED INDEX [CL_int_audit_log_audit_dt_login_id_device_name]
    ON [dbo].[int_audit_log]([audit_dt] ASC, [login_id] ASC, [device_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table logs information that pertains to PATIENT access. Any time the USER accesses a PATIENT, the middle tier will log the accessing information.This information is logged everytime the USER goes beyond the PATIENT_LIST screen. This log is also used for any other logged activities that involve data access (i.e. VIP overrides, search overrides, etc.). Certain modules may have additional log tables to handle unique or high-volume audit requirements. This is intended to only store user-generated events that need to be recorded for very long time periods (or indefinitely).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The user that triggered this audit log entry. FK to their int_user table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'login_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The application that triggered the log entry. It may be NULL if the portal generated the entry or some other non-product specific action caused the entry.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'application_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient record that was accessed. It is possible that this log entry is not patient related in which case this column will be NULL. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code (number) of the type of security event.  These are hard-coded in each application (module). They are not codified in a database table at this time.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'audit_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The IP Address of the machine where the information was accessed. Either the hostname or the Address. OR, this could be some other meaningful description of where the data was accessed (in the browser, it may be whatever the web server has access to).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'device_name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The description of the audit event. Some key data may be encoded in the description.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'audit_descr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time the event was logged (not necessary the exact time the event occurred).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'audit_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this audit event occurred on (if known). FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The result detail record that this audit event occurred for (if known). FK to the results table(s).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_audit_log', @level2type = N'COLUMN', @level2name = N'detail_id';

