CREATE TABLE [Intesys].[ClientMap] (
    [ClientMapID]     INT           IDENTITY (1, 1) NOT NULL,
    [MapType]         NVARCHAR (20) NOT NULL,
    [MapValue]        NVARCHAR (40) NOT NULL,
    [UnitName]        NVARCHAR (50) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_ClientMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ClientMap_ClientMapID] PRIMARY KEY CLUSTERED ([ClientMapID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ClientMap_MapType_MapValue]
    ON [Intesys].[ClientMap]([MapType] ASC, [MapValue] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores the legal code categories used in the int_misc_code table. It is primarily a documentation tool, since very little logic requires these values. It is also used in System Administration. This table is pre-loaded with a set of rows that does not change for a given release.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ClientMap';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Type of mapping. Generally this is just used for IP address (or workstation ID) mappings to a particular unit.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ClientMap', @level2type = N'COLUMN', @level2name = N'MapType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the value of the mapping (i.e. the actual IP address or workstation name)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ClientMap', @level2type = N'COLUMN', @level2name = N'MapValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the Unit (code) that this value is mapped to.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'ClientMap', @level2type = N'COLUMN', @level2name = N'UnitName';

