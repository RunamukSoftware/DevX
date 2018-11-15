CREATE TABLE [dbo].[int_user_settings] (
    [user_id]       UNIQUEIDENTIFIER NOT NULL,
    [cfg_name]      VARCHAR (40)     NOT NULL,
    [cfg_xml_value] XML              NOT NULL,
    CONSTRAINT [PK_int_user_settings_user_id_cfg_name] PRIMARY KEY CLUSTERED ([user_id] ASC, [cfg_name] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Old Intesys user settings table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_user_settings';

