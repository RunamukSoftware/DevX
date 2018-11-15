CREATE TABLE [Intesys].[Diagnosis] (
    [DiagnosisID]           INT            IDENTITY (1, 1) NOT NULL,
    [EncounterID]           INT            NOT NULL,
    [DiagnosisTypeCodeID]   INT            NOT NULL,
    [SequenceNumber]        INT            NOT NULL,
    [DiagnosisCodeID]       INT            NULL,
    [InactiveSwitch]        BIT            NOT NULL,
    [DiagnosisDateTime]     DATETIME2 (7)  NULL,
    [ClassCodeID]           INT            NULL,
    [ConfidentialIndicator] TINYINT        NULL,
    [AttestationDateTime]   DATETIME2 (7)  NULL,
    [Description]           NVARCHAR (255) NULL,
    [CreatedDateTime]       DATETIME2 (7)  CONSTRAINT [DF_Diagnosis_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Diagnosis_DiagnosisID] PRIMARY KEY CLUSTERED ([DiagnosisID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Diagnosis_EncounterID]
    ON [Intesys].[Diagnosis]([EncounterID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The determination in the nature of the disease or problem. It is made form the study of the signs and symptoms of the disease or problem. The diagnosis can either be codified (ex: ICD9 or they can be free-formated text). This table is designed to track the various diagnosis associated with a given ENCOUNTER and PATIENT. The primary key of this table is a combination of the EncounterID, diagnosis_type_cid, and SequenceNumber. This is because an encounter can have multiple diagnosis (including multiple of each Type). The sequence # quarantees uniqueness.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the ENCOUNTER table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that indicates the Type of ENC_DIAGNOSIS. See permitted values. Examples include (Admit, final, etc).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'DiagnosisTypeCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The sequence of this diagnosis for the given encounter. Each encounter can have multiple diagnosis of the same Type.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'SequenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the MISC_CODE table (cat_code=''xxxx''). A code that identifies the PATIENT problem into a specific category. This could be an ICD-9 code. This can be NULL because the diagnosis may not be codified (may be a textual diagnosis that is stored in the dsc column).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'DiagnosisCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A yes/no flag to indicate the state or status of the row associated with this column. When the value is (1), this means that the  diagnosis has a new value from the DB Loader and this current value is no longer an active diagnosis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'InactiveSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains the date/time that the diagnosis was determined.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'DiagnosisDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates if the patient information  is for a diagnosis or a non-diagnosis code.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'ClassCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field indicates whether the diagnosis is confidential. 1=Confidential', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'ConfidentialIndicator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field contains the timestamp that indicates the date that the attestation was signed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'AttestationDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The non-codified diagnosis (if the diagnosis_cid is NULL). This can be a free-formatted description of the diagnosis. Some sites may never use this and only allow codified diagnosis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Diagnosis', @level2type = N'COLUMN', @level2name = N'Description';

