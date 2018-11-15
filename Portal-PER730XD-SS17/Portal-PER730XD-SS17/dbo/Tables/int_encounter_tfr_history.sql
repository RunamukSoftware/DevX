CREATE TABLE [dbo].[int_encounter_tfr_history] (
    [encounter_xid]          NVARCHAR (30)    NOT NULL,
    [organization_id]        UNIQUEIDENTIFIER NOT NULL,
    [encounter_id]           UNIQUEIDENTIFIER NOT NULL,
    [patient_id]             UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]        UNIQUEIDENTIFIER NULL,
    [tfr_txn_dt]             DATETIME         NULL,
    [tfrd_from_encounter_id] UNIQUEIDENTIFIER NULL,
    [tfrd_to_encounter_id]   UNIQUEIDENTIFIER NULL,
    [tfrd_from_patient_id]   UNIQUEIDENTIFIER NULL,
    [tfrd_to_patient_id]     UNIQUEIDENTIFIER NULL,
    [status_cd]              NCHAR (1)        NULL,
    [event_cd]               NVARCHAR (4)     NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_encounter_tfr_history_encounter_xid_organization_id]
    ON [dbo].[int_encounter_tfr_history]([encounter_xid] ASC, [organization_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A table that tracks the moving and merging of encounters within the Database. When an encounter move or merge takes place, this table will capture the surviving and non-surviving patient and encounter ID''s.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An attribute that uniquely identifies the External Visit Number assigned by the ENCOUNTER assigning ORGANIZATION. This is usually the patient number or billing number for simple  encounter/account relationships. Whenever an external system provides an identifier to  the system, that eXternal IDentifier is referred to as an XID.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'encounter_xid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that the encounter that was moved/merged is associated with.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'organization_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that the encounter that was moved/merged is associated with.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient associated with the transfer (not necessarily the source or destination).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time in which the transfer has taken place.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'tfr_txn_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date and time in which the transfer has taken place.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'tfrd_from_encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the ENCOUNTER ENTITY IDENTIFICATION for the surviving ENCOUNTER.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'tfrd_to_encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the ENCOUNTER ENTITY IDENTIFICATION for the non-surviving PATIENT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'tfrd_from_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This attribute identifies the Patient (patient_id) for the surviving PATIENT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'tfrd_to_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state in which the occurrence was created.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'status_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the action that was processed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_tfr_history', @level2type = N'COLUMN', @level2name = N'event_cd';

