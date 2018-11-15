CREATE TABLE [dbo].[int_diagnosis_hcp_int] (
    [encounter_id]       UNIQUEIDENTIFIER NOT NULL,
    [diagnosis_type_cid] INT              NOT NULL,
    [diagnosis_seq_no]   INT              NOT NULL,
    [inactive_sw]        TINYINT          NULL,
    [diagnosis_dt]       DATETIME         NULL,
    [desc_key]           INT              NOT NULL,
    [hcp_id]             UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_diagnosis_hcp_int_encounter_id_diagnosis_type_cid_diagnosis_seq_no_inactive_sw]
    ON [dbo].[int_diagnosis_hcp_int]([encounter_id] ASC, [diagnosis_type_cid] ASC, [diagnosis_seq_no] ASC, [inactive_sw] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table allows for multiple diagnosis clinicians for each encounter diagnosis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'diagnosis_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'diagnosis_seq_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this relationship is active or not (0/NULL=active, 1=inactive).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'inactive_sw';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date of the diagnosis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'diagnosis_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This allows multiple HCP''s for each diagnosis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'desc_key';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP that is "linked" to the diagnosis. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_hcp_int', @level2type = N'COLUMN', @level2name = N'hcp_id';

