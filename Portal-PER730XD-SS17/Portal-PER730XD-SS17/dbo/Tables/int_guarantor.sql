CREATE TABLE [dbo].[int_guarantor] (
    [patient_id]          UNIQUEIDENTIFIER NOT NULL,
    [seq_no]              INT              NOT NULL,
    [type_cd]             NCHAR (2)        NOT NULL,
    [active_sw]           TINYINT          NOT NULL,
    [orig_patient_id]     UNIQUEIDENTIFIER NULL,
    [relationship_cid]    INT              NULL,
    [encounter_id]        UNIQUEIDENTIFIER NULL,
    [ext_organization_id] UNIQUEIDENTIFIER NULL,
    [guarantor_person_id] UNIQUEIDENTIFIER NULL,
    [employer_id]         UNIQUEIDENTIFIER NULL,
    [spouse_id]           UNIQUEIDENTIFIER NULL,
    [contact_id]          UNIQUEIDENTIFIER NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_guarantor_patient_id_seq_no]
    ON [dbo].[int_guarantor]([patient_id] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores guarantor information supplied in the GT1 segment of HL/7.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_guarantor';

