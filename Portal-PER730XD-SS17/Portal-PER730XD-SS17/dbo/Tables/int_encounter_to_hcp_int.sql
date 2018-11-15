CREATE TABLE [dbo].[int_encounter_to_hcp_int] (
    [encounter_id] UNIQUEIDENTIFIER NOT NULL,
    [hcp_id]       UNIQUEIDENTIFIER NOT NULL,
    [hcp_role_cd]  NCHAR (1)        NOT NULL,
    [end_dt]       DATETIME         NULL,
    [active_sw]    TINYINT          NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_encounter_to_hcp_int_encounter_id_hcp_id_hcp_role_cd]
    ON [dbo].[int_encounter_to_hcp_int]([encounter_id] ASC, [hcp_id] ASC, [hcp_role_cd] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the relationship of HCP''s to Encounters. It defines the role(s) a HCP plays for a specific encounter (or multiple HCP''s for a single encounter). Currently, only Consulting physician information is stored (attending, admitting and referring are stored in the encounter table). That is because in HL/7, the only type of physician that there can me multiple is the consulting physician.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The encounter this result is associated with. FK to the encounter table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int', @level2type = N'COLUMN', @level2name = N'encounter_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP that is associated with this encounter. FK to the HCP table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int', @level2type = N'COLUMN', @level2name = N'hcp_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK to the MISC_CODE table (cat_code = xxx). A code that indicates the type of role (category/specialty) for the HEALTHCARE PROVIDER and this particular ENCOUNTER. This is any HEALTHCARE PROVIDER who participates in the care of a PATIENT for a specific episode of care. Ex: Radiologist, Cardiologist, GP, Resident, RN, LPN, LCSW, etc.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int', @level2type = N'COLUMN', @level2name = N'hcp_role_cd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end date and time that the association takes place.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int', @level2type = N'COLUMN', @level2name = N'end_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this relationship is active (or whether it was unlinked). 1=Active, 0=No longer active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_encounter_to_hcp_int', @level2type = N'COLUMN', @level2name = N'active_sw';

