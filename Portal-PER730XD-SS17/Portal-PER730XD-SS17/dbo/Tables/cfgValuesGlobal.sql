CREATE TABLE [dbo].[cfgValuesGlobal] (
    [type_cd]       VARCHAR (25)        NOT NULL,
    [cfg_name]      VARCHAR (40)        NOT NULL,
    [cfg_value]     [dbo].[DCFG_VALUES] NULL,
    [cfg_xml_value] XML                 NULL,
    [value_type]    VARCHAR (20)        NOT NULL,
    [global_type]   BIT                 NOT NULL,
    CONSTRAINT [PK_ValuesGlobalConst_type_cd_cfg_name] PRIMARY KEY CLUSTERED ([type_cd] ASC, [cfg_name] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains global CH settings (gets populated if user goes into ICS Admin and overwrites factory defaults). type_cd and cfg_name should be PKs.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cfgValuesGlobal';

