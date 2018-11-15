CREATE TABLE [dbo].[int_pref] (
    [user_id]        UNIQUEIDENTIFIER NULL,
    [user_role_id]   UNIQUEIDENTIFIER NULL,
    [application_id] NCHAR (3)        NULL,
    [xml_data]       IMAGE            NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_pref_user_id_user_role_id]
    ON [dbo].[int_pref]([user_id] ASC, [user_role_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores preferences for all users, roles and global. These preferences are stored as an XML string that each application defines. The XML hierarchy allows each application to have a very large number of preferences and to add/remove values without requiring a database change. Preferences are any user configuration values that do NOT deal with security AND are generally available for the user to change. Preferences and security are arranged into a 3-tier hierarchy (Global->Role->User). There is the capability for a lower level to override a higher level. There is also the ability for the higher level to lock down the value (prevent lower-level overrides).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_pref';

