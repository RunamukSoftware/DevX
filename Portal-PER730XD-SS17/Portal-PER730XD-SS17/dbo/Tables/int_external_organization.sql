CREATE TABLE [dbo].[int_external_organization] (
    [ext_organization_id]        UNIQUEIDENTIFIER NOT NULL,
    [cat_code]                   NCHAR (1)        NULL,
    [organization_nm]            NVARCHAR (50)    NULL,
    [parent_ext_organization_id] UNIQUEIDENTIFIER NULL,
    [organization_cd]            NVARCHAR (30)    NULL,
    [company_cons]               NVARCHAR (50)    NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_external_organization_ext_organization_id]
    ON [dbo].[int_external_organization]([ext_organization_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores all "external" organizations. External organizations have been separated from internal organizations. External organizations are organizations that are not located within the hospital or facility such as insurance companies and employers. Internal organizations are those that are part of the hospital or facility such as  units.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_external_organization';

