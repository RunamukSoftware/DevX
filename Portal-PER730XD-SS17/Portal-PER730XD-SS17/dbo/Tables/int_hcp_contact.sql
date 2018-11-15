CREATE TABLE [dbo].[int_hcp_contact] (
    [hcp_id]           UNIQUEIDENTIFIER NOT NULL,
    [contact_type_cid] INT              NOT NULL,
    [seq_no]           SMALLINT         NOT NULL,
    [hcp_contact_no]   NVARCHAR (40)    NOT NULL,
    [hcp_contact_ext]  NVARCHAR (12)    NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_hcp_contact_hcp_id_contact_type_cid_seq_no]
    ON [dbo].[int_hcp_contact]([hcp_id] ASC, [contact_type_cid] ASC, [seq_no] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines the contact information for HCP''s. This includes phone #''s, pagers, e-mail addresses, etc.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_hcp_contact';

