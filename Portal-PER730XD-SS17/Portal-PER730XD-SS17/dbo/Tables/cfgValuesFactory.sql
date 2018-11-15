CREATE TABLE [dbo].[cfgValuesFactory] (
    [type_cd]       VARCHAR (25)        NOT NULL,
    [cfg_name]      VARCHAR (40)        NOT NULL,
    [cfg_value]     [dbo].[DCFG_VALUES] NULL,
    [cfg_xml_value] XML                 NULL,
    [value_type]    VARCHAR (20)        NOT NULL,
    [global_type]   BIT                 NOT NULL,
    CONSTRAINT [PK_ValuesFactoryConst_type_cd_cfg_name] PRIMARY KEY CLUSTERED ([type_cd] ASC, [cfg_name] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains factory defaults for CH settings. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cfgValuesFactory';

