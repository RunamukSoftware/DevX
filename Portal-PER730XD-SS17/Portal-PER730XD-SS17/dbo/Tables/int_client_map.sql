CREATE TABLE [dbo].[int_client_map] (
    [map_type] NVARCHAR (20) NOT NULL,
    [map_val]  NVARCHAR (40) NOT NULL,
    [unit_nm]  NVARCHAR (50) NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_client_map_map_type_map_val]
    ON [dbo].[int_client_map]([map_type] ASC, [map_val] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the legal code categories used in the int_misc_code table. It is primarily a documentation tool, since very little logic requires these values. It is also used in System Administration. This table is pre-loaded with a set of rows that does not change for a given release.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_client_map';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The type of mapping. Generally this is just used for IP address (or workstation ID) mappings to a particular unit.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_client_map', @level2type = N'COLUMN', @level2name = N'map_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the value of the mapping (i.e. the actual IP address or workstation name)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_client_map', @level2type = N'COLUMN', @level2name = N'map_val';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the Unit (code) that this value is mapped to.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_client_map', @level2type = N'COLUMN', @level2name = N'unit_nm';

