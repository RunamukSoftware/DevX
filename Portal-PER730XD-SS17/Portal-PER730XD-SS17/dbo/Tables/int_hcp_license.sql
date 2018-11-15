CREATE TABLE [dbo].[int_hcp_license] (
    [hcp_id]             UNIQUEIDENTIFIER NOT NULL,
    [license_type_cid]   INT              NOT NULL,
    [license_state_code] NVARCHAR (3)     NOT NULL,
    [license_xid]        NVARCHAR (10)    NULL,
    [effective_dt]       DATETIME         NULL,
    [expiration_dt]      DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_hcp_license_hcp_id_license_type_cid_license_xid_license_state_code]
    ON [dbo].[int_hcp_license]([hcp_id] ASC, [license_type_cid] ASC, [license_xid] ASC, [license_state_code] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all certification(s) associated with each HCP. A certification that is acquired by a HEALTHCARE PROFESSIONAL to provide a service in a Healthcare FACILITY/ORGANIZATION.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_hcp_license';

