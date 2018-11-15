CREATE TABLE [dbo].[cfgValuesUnit] (
    [unit_id]       UNIQUEIDENTIFIER    NOT NULL,
    [type_cd]       VARCHAR (25)        NOT NULL,
    [cfg_name]      VARCHAR (40)        NOT NULL,
    [cfg_value]     [dbo].[DCFG_VALUES] NULL,
    [cfg_xml_value] XML                 NULL,
    [value_type]    VARCHAR (20)        NOT NULL,
    CONSTRAINT [PK_ValuesUnitConst_unit_id_type_cd_cfg_name] PRIMARY KEY CLUSTERED ([unit_id] ASC, [type_cd] ASC, [cfg_name] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains CH unit settings (gets populated if user goes into ICS Admin and modifies settings for a given unit). type_cd, cfg_name, and unit_id should be PKs.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cfgValuesUnit';

