CREATE TABLE [dbo].[int_procedure_hcp_int] (
    [encounter_id]      UNIQUEIDENTIFIER NOT NULL,
    [procedure_cid]     INT              NOT NULL,
    [seq_no]            INT              NOT NULL,
    [desc_key]          INT              NOT NULL,
    [hcp_id]            UNIQUEIDENTIFIER NOT NULL,
    [proc_hcp_type_cid] INT              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_procedure_hcp_int_encounter_id_procedure_cid_seq_no_desc_key]
    ON [dbo].[int_procedure_hcp_int]([encounter_id] ASC, [procedure_cid] ASC, [seq_no] ASC, [desc_key] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the HCP(s) that were involved in a procedure. There can multiple HCP(s) for each procedure and multiple types of HCP(s).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_procedure_hcp_int';

