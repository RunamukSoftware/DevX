CREATE TABLE [dbo].[int_patient_procedure] (
    [enc_id]             UNIQUEIDENTIFIER NOT NULL,
    [proc_cid]           INT              NOT NULL,
    [seq_no]             SMALLINT         NOT NULL,
    [proc_dt]            DATETIME         NOT NULL,
    [proc_function_cid]  INT              NOT NULL,
    [proc_minutes]       SMALLINT         NOT NULL,
    [anesthesia_cid]     INT              NULL,
    [anesthesia_minutes] SMALLINT         NULL,
    [consent_cid]        INT              NOT NULL,
    [proc_priority]      TINYINT          NULL,
    [assoc_diag_cid]     INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_procedure_enc_id_proc_cid]
    ON [dbo].[int_patient_procedure]([enc_id] ASC, [proc_cid] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information relative to various types of procedures that can be performed on a patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_procedure';

