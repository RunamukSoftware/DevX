CREATE TABLE [dbo].[int_procedure] (
    [encounter_id]           INT      NOT NULL,
    [procedure_cid]          INT      NOT NULL,
    [seq_no]                 BIT      NOT NULL,
    [procedure_dt]           DATETIME NOT NULL,
    [procedure_function_cid] INT      NOT NULL,
    [procedure_minutes]      BIT      NOT NULL,
    [anesthesia_cid]         INT      NULL,
    [anesthesia_minutes]     BIT      NULL,
    [consent_cid]            INT      NOT NULL,
    [procedure_priority]     BIT      NULL,
    [assoc_diag_cid]         INT      NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_procedure_encounter_id_procedure_cid_seq_no]
    ON [dbo].[int_procedure]([encounter_id] ASC, [procedure_cid] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information relative to various types of procedures that can be performed on a patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_procedure';

