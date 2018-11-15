CREATE TABLE [dbo].[int_pref_lock] (
    [user_id]      UNIQUEIDENTIFIER NULL,
    [user_role_id] UNIQUEIDENTIFIER NULL,
    [node_path]    NVARCHAR (255)   NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_pref_lock_user_id_user_role_id_node_path]
    ON [dbo].[int_pref_lock]([user_id] ASC, [user_role_id] ASC, [node_path] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores any locks that are applied (at any level). Locks prevent lower levels from having different values than the current level. For example, if a value is locked at global, then all user_role''s and users must have the same value. This allows a site to prevent users from changing certain preferences. By default, users can change any preference unless they are locked.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_pref_lock';

