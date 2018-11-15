CREATE TABLE [Intesys].[DiagnosisHealthCareProviderInt] (
    [DiagnosisHealthCareProviderInt] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [EncounterID]                    INT           NOT NULL,
    [DiagnosisTypeCodeID]            INT           NOT NULL,
    [DiagnosisSequenceNumber]        INT           NOT NULL,
    [InactiveSwitch]                 BIT           NOT NULL,
    [DiagnosisDateTime]              DATETIME2 (7) NULL,
    [DescriptionKey]                 INT           NOT NULL,
    [HealthCareProviderID]           INT           NULL,
    [CreatedDateTime]                DATETIME2 (7) CONSTRAINT [DF_DiagnosisHealthCareProviderInt_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DiagnosisHealthCareProviderInt_DiagnosisHealthCareProviderIntID] PRIMARY KEY CLUSTERED ([DiagnosisHealthCareProviderInt] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DiagnosisHealthCareProviderInt_EncounterID_DiagnosisTypeCodeID_DiagnosisSequenceNumber_InactiveSwitch]
    ON [Intesys].[DiagnosisHealthCareProviderInt]([EncounterID] ASC, [DiagnosisTypeCodeID] ASC, [DiagnosisSequenceNumber] ASC, [InactiveSwitch] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table allows for multiple diagnosis clinicians for each encounter diagnosis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'DiagnosisTypeCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this diagnosis/HCP refers to. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'DiagnosisSequenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this relationship is active or not (0/NULL=active, 1=inactive).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'InactiveSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date of the diagnosis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'DiagnosisDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This allows multiple HCP''s for each diagnosis.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'DescriptionKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP that is "linked" to the diagnosis. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'DiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'HealthCareProviderID';

