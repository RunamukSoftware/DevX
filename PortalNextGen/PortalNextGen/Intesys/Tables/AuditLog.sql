CREATE TABLE [Intesys].[AuditLog] (
    [AuditLogID]        INT            IDENTITY (1, 1) NOT NULL,
    [LoginID]           INT            NULL,
    [ApplicationID]     INT            NULL,
    [PatientID]         INT            NULL,
    [OriginalPatientID] INT            NULL,
    [AuditType]         NVARCHAR (160) NULL,
    [DeviceName]        NVARCHAR (64)  NULL,
    [AuditDescription]  NVARCHAR (500) NULL,
    [AuditDateTime]     DATETIME2 (7)  NOT NULL,
    [EncounterID]       INT            NULL,
    [DetailID]          INT            NULL,
    [CreatedDateTime]   DATETIME2 (7)  CONSTRAINT [DF_AuditLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Intesys_AuditLog_AuditLogID] PRIMARY KEY CLUSTERED ([AuditLogID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_AuditLog_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_AuditLog_AuditDateTime_LoginID_DeviceName]
    ON [Intesys].[AuditLog]([AuditDateTime] ASC, [LoginID] ASC, [DeviceName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table logs information that pertains to PATIENT access. Any time the USER accesses a PATIENT, the middle tier will log the accessing information.This information is logged everytime the USER goes beyond the PATIENT_LIST screen. This log is also used for any other logged activities that involve data access (i.e. VIP overrides, search overrides, etc.). Certain modules may have additional log tables to handle unique or high-volume audit requirements. This is intended to only store user-generated events that need to be recorded for very long time periods (or indefinitely).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The user that triggered this audit log entry. FK to their int_user table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'LoginID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The application that triggered the log entry. It may be NULL if the portal generated the entry or some other non-product specific action caused the entry.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'ApplicationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient record that was accessed. It is possible that this log entry is not patient related in which case this column will be NULL. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code (number) of the Type of security event.  These are hard-coded in each application (module). They are not codified in a database table at this time.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'AuditType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The IP Address of the machine where the information was accessed. Either the hostname or the Address. OR, this could be some other meaningful description of where the data was accessed (in the browser, it may be whatever the web server has access to).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'DeviceName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The description of the audit event. Some key data may be encoded in the description.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'AuditDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time the event was logged (not necessary the exact time the event occurred).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'AuditDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this audit event occurred on (if known). FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The result detail record that this audit event occurred for (if known). FK to the results table(s).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AuditLog', @level2type = N'COLUMN', @level2name = N'DetailID';

