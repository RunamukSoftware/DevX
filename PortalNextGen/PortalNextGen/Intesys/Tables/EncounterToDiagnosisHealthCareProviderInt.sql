CREATE TABLE [Intesys].[EncounterToDiagnosisHealthCareProviderInt] (
    [EncounterToDiagnosisHealthCareProviderInt] BIGINT        IDENTITY (-9223372036854775808, 1) NOT NULL,
    [EncounterID]                               INT           NOT NULL,
    [HealthCareProviderID]                      INT           NOT NULL,
    [HealthCareProviderRoleCode]                NCHAR (1)     NOT NULL,
    [EndDateTime]                               DATETIME2 (7) NULL,
    [ActiveSwitch]                              BIT           NOT NULL,
    [CreatedDateTime]                           DATETIME2 (7) CONSTRAINT [DF_EncounterToDiagnosisHealthCareProviderInt_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_EncounterToDiagnosisHealthCareProviderInt_EncounterToDiagnosisHealthCareProviderIntID] PRIMARY KEY CLUSTERED ([EncounterToDiagnosisHealthCareProviderInt] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_EncounterToDiagnosisHealthCareProviderInt_Encounter_EncounterID] FOREIGN KEY ([EncounterID]) REFERENCES [Intesys].[Encounter] ([EncounterID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EncounterToDiagnosisHealthCareProviderInt_EncounterID_HealthCareProviderID_HealthCareProviderRoleCode]
    ON [Intesys].[EncounterToDiagnosisHealthCareProviderInt]([EncounterID] ASC, [HealthCareProviderID] ASC, [HealthCareProviderRoleCode] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the relationship of HCP''s to Encounters. It defines the role(s) a HCP plays for a specific encounter (or multiple HCP''s for a single encounter). Currently, only Consulting physician information is stored (attending, admitting and referring are stored in the encounter table). That is because in HL/7, the only Type of physician that there can me multiple is the consulting physician.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'EncounterID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP that is associated with this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'HealthCareProviderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the MISC_CODE table (cat_code = xxx). A code that indicates the Type of role (category/specialty) for the HEALTHCARE PROVIDER and this particular ENCOUNTER. This is any HEALTHCARE PROVIDER who participates in the care of a PATIENT for a specific episode of care. Ex: Radiologist, Cardiologist, GP, Resident, RN, LPN, LCSW, etc.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'HealthCareProviderRoleCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end date and time that the association takes place.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'EndDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this relationship is active (or whether it was unlinked). 1=Active, 0=No longer active', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'EncounterToDiagnosisHealthCareProviderInt', @level2type = N'COLUMN', @level2name = N'ActiveSwitch';

