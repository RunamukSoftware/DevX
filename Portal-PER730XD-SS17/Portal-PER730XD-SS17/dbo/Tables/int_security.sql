CREATE TABLE [dbo].[int_security] (
    [user_id]        UNIQUEIDENTIFIER NULL,
    [user_role_id]   UNIQUEIDENTIFIER NULL,
    [application_id] NCHAR (3)        NULL,
    [xml_data]       XML              NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_security_user_id_user_role_id]
    ON [dbo].[int_security]([user_id] ASC, [user_role_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores security settings for all users, roles and global. These security settings are stored as an XML string that each application defines. The XML hierarchy allows each application to have a very large number of security settings and to add/remove values without requiring a database change. Security settings are any setting that controls access to data and/or applications that are defined and controlled by administrators. Preferences and security are arranged into a 3-tier hierarchy (Global->Role->User). There is the capability for a lower level to override a higher level. There is also the ability for the higher level to lock down the value (prevent lower-level overrides).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_security';

