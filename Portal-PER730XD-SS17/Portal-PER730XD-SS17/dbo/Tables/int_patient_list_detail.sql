CREATE TABLE [dbo].[int_patient_list_detail] (
    [patient_list_id]   UNIQUEIDENTIFIER NOT NULL,
    [patient_id]        UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]   UNIQUEIDENTIFIER NULL,
    [encounter_id]      UNIQUEIDENTIFIER NOT NULL,
    [deleted]           TINYINT          NOT NULL,
    [new_results]       CHAR (1)         NULL,
    [viewed_results_dt] DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_list_detail_patient_list_id_patient_id_encounter_id]
    ON [dbo].[int_patient_list_detail]([patient_list_id] ASC, [patient_id] ASC, [encounter_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_patient_list_detail_orig_patient_id]
    ON [dbo].[int_patient_list_detail]([orig_patient_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the patients that exist on a given patient list. It is the detail for a patient list. It therefore contains all patient entries for all patient lists (Unit, practicing, personal, etc.) It does not contain entries for the Search or Group lists (these are generated at run-time).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_list_detail';

