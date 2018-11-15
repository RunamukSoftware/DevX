CREATE TABLE [dbo].[int_hcp] (
    [hcp_id]           UNIQUEIDENTIFIER NOT NULL,
    [hcp_type_cid]     INT              NULL,
    [last_nm]          NVARCHAR (50)    NULL,
    [first_nm]         NVARCHAR (50)    NULL,
    [middle_nm]        NVARCHAR (50)    NULL,
    [degree]           NVARCHAR (20)    NULL,
    [verification_sw]  TINYINT          NULL,
    [doctor_ins_no_id] NVARCHAR (10)    NULL,
    [doctor_dea_no]    NVARCHAR (10)    NULL,
    [medicare_id]      NVARCHAR (12)    NULL,
    [medicaid_id]      NVARCHAR (20)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_hcp_hcp_id]
    ON [dbo].[int_hcp]([hcp_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The HCP table stores all HCP''s referenced in HL/7 messages. HCP''s are any individuals who perform a role as a clinical employee, provider or authorized affiliates of a Healthcare ORGANIZATION. The HCP''s name (first name, last name, middle initial, and degree) are carried as redundant data within the HCP table in order to eliminate a join back to the PERSON_NAME table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_hcp';

