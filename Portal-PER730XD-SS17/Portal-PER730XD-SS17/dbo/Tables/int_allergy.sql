CREATE TABLE [dbo].[int_allergy] (
    [patient_id]        UNIQUEIDENTIFIER NOT NULL,
    [allergy_cid]       INT              NOT NULL,
    [orig_patient_id]   UNIQUEIDENTIFIER NULL,
    [allergy_type_cid]  INT              NULL,
    [severity_cid]      INT              NULL,
    [reaction]          NVARCHAR (255)   NULL,
    [identification_dt] DATETIME         NULL,
    [active_sw]         NCHAR (1)        NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_allergy_patient_id_allergy_cid_reaction_identification_dt_active_sw]
    ON [dbo].[int_allergy]([patient_id] ASC, [allergy_cid] ASC, [reaction] ASC, [identification_dt] ASC, [active_sw] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains data for allergies on a patient for an encounter. It can also store "lifetime" or permanent allergies (ones that are independent of encounters).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The patient this allergy belongs to. FK to the PATIENT table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The allergy code id for the patient/encounter. FK to the MISC_CODE table (cat_code = ''ALGRY''). For each pat_ent_id/enc_ent_id this  code id will be unique. HL7: Seg AL1, Item# 00205.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'allergy_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The original patient ID (if linked). Used by MPI logic to "unlink" a patient if necessary.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'orig_patient_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The type of allergy. For example:   DA Drug Allergy   FA  Food Allergy   MA  Misc Allergy   MC  Misc Contraindication', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'allergy_type_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The severity of the allergy. For example:   SV  Severe   MO Moderate   MI   Mild. FK to the misc code table (cat = "ALGSEV"). HL7 - Seg AL1, Item# 00206.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'severity_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Short textual description of the specific allergy reaction (convulsions, sneeze, rash, etc.). HL7 - Seg AL1, Item# 00207.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'reaction';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the allergy was identified. HL7 - Seg AL1, Item# 00208.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'identification_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this allergy is still active. Allergies can be "deactivated" if the allergy no longer persists.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_allergy', @level2type = N'COLUMN', @level2name = N'active_sw';

