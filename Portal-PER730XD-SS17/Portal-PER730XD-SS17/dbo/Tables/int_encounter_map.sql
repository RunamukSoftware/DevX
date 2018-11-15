CREATE TABLE [dbo].[int_encounter_map] (
    [encounter_xid]   NVARCHAR (40)    NOT NULL,
    [organization_id] UNIQUEIDENTIFIER NOT NULL,
    [encounter_id]    UNIQUEIDENTIFIER NOT NULL,
    [patient_id]      UNIQUEIDENTIFIER NOT NULL,
    [seq_no]          INT              NOT NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [status_cd]       NCHAR (1)        NULL,
    [event_cd]        NVARCHAR (4)     NULL,
    [account_id]      UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_encounter_map_encounter_xid_organization_id_patient_id_status_cd_account_id_seq_no]
    ON [dbo].[int_encounter_map]([encounter_xid] ASC, [organization_id] ASC, [patient_id] ASC, [status_cd] ASC, [account_id] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_map_encounter_id]
    ON [dbo].[int_encounter_map]([encounter_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_encounter_map_patient_id]
    ON [dbo].[int_encounter_map]([patient_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A table that assigns an external visit number to an internal encounter record. This table allows an organization''s specific healthcare identifier (i.e. visit) to be mapped into a unique internal identifier (encounter_id). Within a specific organization, their identifiers for an encounter must be unique.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The external ID for the encounter (encounter number). These numbers must be unique for each organization.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'encounter_xid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization that this external ID is assigned by.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'organization_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient this encounter is associated with. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequence # guarantees a unique record.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'seq_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state in which the occurrence was created.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'status_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A code that identifies the action that was processed  Probably not currently used', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'event_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account that is associated with this encounter link.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_map', @level2type = N'COLUMN', @level2name = N'account_id';

