CREATE TABLE [dbo].[int_pref_pushdown] (
    [user_id]      UNIQUEIDENTIFIER NULL,
    [user_role_id] UNIQUEIDENTIFIER NULL,
    [node_path]    NVARCHAR (255)   NOT NULL,
    [xml_data]     NVARCHAR (4000)  NOT NULL,
    [mod_dt]       DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_pref_pushdown_user_id_user_role_id_node_path]
    ON [dbo].[int_pref_pushdown]([user_id] ASC, [user_role_id] ASC, [node_path] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores "pushdowns". A pushdown is an attempt by the administrator to push-out a value to all users of the global or user_role level. When a change is made by the administrator to a preference at the global or category level, the default is to "push out" the new value to all users affected by that level. However, there are times when an administrator may want to make a change to the value for a level, but leave the current user''s value alone. This is particularly true when talking about display preferences for sorting, etc. By changing a value and not pushing it out, the administrator is changing new users (before they have a chance to set/save their prefs). A pushdown record is removed once a user logs in. Pushdown''s could be proprogated to the actual int_pref table as soon as possible, but this would require a lot of processing time during each change made at the global or category levels.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_pref_pushdown';

