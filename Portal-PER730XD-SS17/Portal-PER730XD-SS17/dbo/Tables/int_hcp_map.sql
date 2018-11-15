CREATE TABLE [dbo].[int_hcp_map] (
    [organization_id] UNIQUEIDENTIFIER NOT NULL,
    [hcp_xid]         NVARCHAR (20)    NOT NULL,
    [hcp_id]          UNIQUEIDENTIFIER NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_hcp_map_organization_id_hcp_xid]
    ON [dbo].[int_hcp_map]([organization_id] ASC, [hcp_xid] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table maps the external id for an HCP to the internal id (HCP_ID). An HCP may have multiple external id''s so this table is required. However, within an organization, ID''s must be unique.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_hcp_map';

