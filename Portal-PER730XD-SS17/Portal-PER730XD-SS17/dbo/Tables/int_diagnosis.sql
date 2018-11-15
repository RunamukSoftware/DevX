CREATE TABLE [dbo].[int_diagnosis] (
    [encounter_id]       UNIQUEIDENTIFIER NOT NULL,
    [diagnosis_type_cid] INT              NOT NULL,
    [seq_no]             INT              NOT NULL,
    [diagnosis_cid]      INT              NULL,
    [inactive_sw]        TINYINT          NULL,
    [diagnosis_dt]       DATETIME         NULL,
    [class_cid]          INT              NULL,
    [confidential_ind]   TINYINT          NULL,
    [attestation_dt]     DATETIME         NULL,
    [dsc]                NVARCHAR (255)   NULL,
    CONSTRAINT [PK_int_diagnosis_encounter_id] PRIMARY KEY CLUSTERED ([encounter_id] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The determination in the nature of the disease or problem. It is made form the study of the signs and symptoms of the disease or problem. The diagnosis can either be codified (ex: ICD9 or they can be free-formated text). This table is designed to track the various diagnosis associated with a given ENCOUNTER and PATIENT. The primary key of this table is a combination of the encounter_id, diagnosis_type_cid, and seq_no. This is because an encounter can have multiple diagnosis (including multiple of each type). The sequence # quarantees uniqueness.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the ENCOUNTER table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that indicates the type of ENC_DIAGNOSIS. See permitted values. Examples include (Admit, final, etc).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'diagnosis_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence of this diagnosis for the given encounter. Each encounter can have multiple diagnosis of the same type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'seq_no';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the MISC_CODE table (cat_code=''xxxx''). A code that identifies the PATIENT problem into a specific category. This could be an ICD-9 code. This can be NULL because the diagnosis may not be codified (may be a textual diagnosis that is stored in the dsc column).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'diagnosis_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A yes/no flag to indicate the state or status of the row associated with this column. When the value is (1), this means that the  diagnosis has a new value from the DB Loader and this current value is no longer an active diagnosis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'inactive_sw';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains the date/time that the diagnosis was determined.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'diagnosis_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates if the patient information  is for a diagnosis or a non-diagnosis code.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'class_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates whether the diagnosis is confidential. 1=Confidential', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'confidential_ind';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains the timestamp that indicates the date that the attestation was signed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'attestation_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The non-codified diagnosis (if the diagnosis_cid is NULL). This can be a free-formatted description of the diagnosis. Some sites may never use this and only allow codified diagnosis.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_diagnosis', @level2type = N'COLUMN', @level2name = N'dsc';

