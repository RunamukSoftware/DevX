CREATE TABLE [dbo].[int_cfg_values] (
    [keyname]  VARCHAR (40)  NOT NULL,
    [keyvalue] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_int_cfg_values_keyname] PRIMARY KEY CLUSTERED ([keyname] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains information about system''s configurations values.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_cfg_values';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Configuration parameter''s name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_cfg_values', @level2type = N'COLUMN', @level2name = N'keyname';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Parameter''s value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_cfg_values', @level2type = N'COLUMN', @level2name = N'keyvalue';

