CREATE TABLE [dbo].[int_patient_document] (
    [patient_id]      UNIQUEIDENTIFIER NULL,
    [seq_no]          INT              NULL,
    [orig_patient_id] UNIQUEIDENTIFIER NULL,
    [document_id]     NVARCHAR (80)    NULL,
    [node_id]         INT              NULL,
    [document_dt]     DATETIME         NULL,
    [document_desc]   NVARCHAR (80)    NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_patient_document_patient_id]
    ON [dbo].[int_patient_document]([patient_id] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table links document images (Optika) to a patient. And indexing application would insert into this table linking the document to the patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_patient_document';

