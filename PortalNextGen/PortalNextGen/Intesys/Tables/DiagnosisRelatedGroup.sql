CREATE TABLE [Intesys].[DiagnosisRelatedGroup] (
    [DiagnosisRelatedGroupID]                          INT           IDENTITY (1, 1) NOT NULL,
    [PatientID]                                        INT           NOT NULL,
    [EncounterID]                                      INT           NOT NULL,
    [AccountID]                                        INT           NOT NULL,
    [DescriptionKey]                                   INT           NOT NULL,
    [OriginalPatientID]                                INT           NULL,
    [DiagnosisRelatedGroupCodeID]                      INT           NULL,
    [DiagnosisRelatedGroupAssignmentDateTime]          DATETIME2 (7) NULL,
    [DiagnosisRelatedGroupApprovalIndicator]           NCHAR (2)     NULL,
    [DiagnosisRelatedGroupGrperReviewCodeID]           INT           NULL,
    [DiagnosisRelatedGroupOutlierCodeID]               INT           NULL,
    [DiagnosisRelatedGroupOutlierDaysNumber]           INT           NULL,
    [DiagnosisRelatedGroupOutlierCostAmount]           SMALLMONEY    NULL,
    [DiagnosisRelatedGroupGrperVerificationTypeCodeID] INT           NULL,
    [CreatedDateTime]                                  DATETIME2 (7) CONSTRAINT [DF_DiagnosisRelatedGroup_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DiagnosisRelatedGroup_DiagnosisRelatedGroupID] PRIMARY KEY CLUSTERED ([DiagnosisRelatedGroupID] ASC),
    CONSTRAINT [FK_DiagnosisRelatedGroup_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DiagnosisRelatedGroup_DescriptionKey]
    ON [Intesys].[DiagnosisRelatedGroup]([DescriptionKey] ASC) WITH (FILLFACTOR = 100);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DiagnosisRelatedGroup_PatientID_EncounterID_AccountID_DescriptionKey]
    ON [Intesys].[DiagnosisRelatedGroup]([PatientID] ASC, [EncounterID] ASC, [AccountID] ASC, [DescriptionKey] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A classification of diagnosis in which a particular ACCOUNT can be tracked for one or more ENCOUNTERs. This is a snapshot of codes at a given point in time. DRG information takes a snapshot of existing diagnosis. Contains code, description, when it was calculated, age, sex, who calculated. Physicians have to sign attestatinos that codes are assigned in correct sequence. DRG''s are applied at the end of the ENCOUNTER. Interim DRG''s are only performed to know how a hospital is doing against average Length Of Stay (LOS), etc. DRG codes appl to inpatient accounts. (Outpatient accounts do not yet have a set of codes for this purpose. Ambulatory product groups is most likely to become the coding scheme for outpatient.) DRG coding scheme contains regional norms, local norms, and adjustment for age. This table contains diagnostic related group (DRG) information specific to the combination entered in the PAT_ACCT_ENC_INT table. The DRG information is the standard HL7 required DRG information.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient associated with this DRG. FK to the patient table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'PatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter associated with this DRG. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The account associated with this DRG. FK to the account table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'AccountID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A descending key to guarantee uniqueness for this table (part of the PK). Also used to get the most recent record.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DescriptionKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient (used by MPI linking).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'OriginalPatientID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the Diagnostic Related Group (DRG) for the ACCOUNT. Defined in HL/7.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the ACCOUNT_DRG was assigned to a specific group.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupAssignmentDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code to indicate if an ACCOUNT_DRG has been approved. Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupApprovalIndicator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code to indicate what Type of assignment has taken place. Ex: A - Admit        P - Preliminary        F - Final Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupGrperReviewCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' A code that categorizes the reason for the DRG OUTLIER DAYS NO. Defined in HL/7', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupOutlierCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The number of days as defined by the DRG outlier.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupOutlierDaysNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' The amount that is allocated to a DRG Outlier', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupOutlierCostAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field relates to the broad category for a disease Type. Defined in HL/7 (DG1)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisRelatedGroup', @level2type = N'COLUMN', @level2name = N'DiagnosisRelatedGroupGrperVerificationTypeCodeID';

