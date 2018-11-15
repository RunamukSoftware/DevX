CREATE TABLE [dbo].[int_security_diff] (
    [user_id]           UNIQUEIDENTIFIER NULL,
    [user_role_id]      UNIQUEIDENTIFIER NULL,
    [node_path]         NVARCHAR (255)   NOT NULL,
    [changed_at_global] TINYINT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_security_diff_user_role_id_node_path_user_id_changed_at_global]
    ON [dbo].[int_security_diff]([user_role_id] ASC, [node_path] ASC, [user_id] ASC, [changed_at_global] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines "Differences" that occur when a lower-level value is changed. This only occurs when a user or role value is changed. It is used to quickly display a change indicator at the global or role level if a lower-level value is different from the higher-level value. These records are only removed if a push-down is applied for a specific level in the XML.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_security_diff';

