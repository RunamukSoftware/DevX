CREATE TABLE [dbo].[int_diagnosis_drg] (
    [patient_id]             UNIQUEIDENTIFIER NOT NULL,
    [encounter_id]           UNIQUEIDENTIFIER NOT NULL,
    [account_id]             UNIQUEIDENTIFIER NOT NULL,
    [desc_key]               INT              NOT NULL,
    [orig_patient_id]        UNIQUEIDENTIFIER NULL,
    [drg_cid]                INT              NULL,
    [drg_assignment_dt]      DATETIME         NULL,
    [drg_approval_ind]       NCHAR (2)        NULL,
    [drg_grper_rvw_cid]      INT              NULL,
    [drg_outlier_cid]        INT              NULL,
    [drg_outlier_days_no]    INT              NULL,
    [drg_outlier_cost_amt]   SMALLMONEY       NULL,
    [drg_grper_ver_type_cid] INT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_diagnosis_drg_patient_id_encounter_id_account_id_desc_key]
    ON [dbo].[int_diagnosis_drg]([patient_id] ASC, [encounter_id] ASC, [account_id] ASC, [desc_key] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_diagnosis_drg_desc_key]
    ON [dbo].[int_diagnosis_drg]([desc_key] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A classification of diagnosis in which a particular ACCOUNT can be tracked for one or more ENCOUNTERs. This is a snapshot of codes at a given point in time. DRG information takes a snapshot of existing diagnosis. Contains code, description, when it was calculated, age, sex, who calculated. Physicians have to sign attestatinos that codes are assigned in correct sequence. DRG''s are applied at the end of the ENCOUNTER. Interim DRG''s are only performed to know how a hospital is doing against average Length Of Stay (LOS), etc. DRG codes appl to inpatient accounts. (Outpatient accounts do not yet have a set of codes for this purpose. Ambulatory product groups is most likely to become the coding scheme for outpatient.) DRG coding scheme contains regional norms, local norms, and adjustment for age. This table contains diagnostic related group (DRG) information specific to the combination entered in the PAT_ACCT_ENC_INT table. The DRG information is the standard HL7 required DRG information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient associated with this DRG. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter associated with this DRG. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account associated with this DRG. FK to the account table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'account_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A descending key to guarantee uniqueness for this table (part of the PK). Also used to get the most recent record.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'desc_key';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the Diagnostic Related Group (DRG) for the ACCOUNT. Defined in HL/7.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the ACCOUNT_DRG was assigned to a specific group.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_assignment_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code to indicate if an ACCOUNT_DRG has been approved. Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_approval_ind';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code to indicate what type of assignment has taken place. Ex: A - Admit        P - Preliminary        F - Final Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_grper_rvw_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A code that categorizes the reason for the DRG OUTLIER DAYS NO. Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_outlier_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The number of days as defined by the DRG outlier.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_outlier_days_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' The amount that is allocated to a DRG Outlier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_outlier_cost_amt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field relates to the broad category for a disease type. Defined in HL/7 (DG1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis_drg', @level2type = N'COLUMN', @level2name = N'drg_grper_ver_type_cid';

