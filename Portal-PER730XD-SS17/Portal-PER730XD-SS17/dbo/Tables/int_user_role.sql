CREATE TABLE [dbo].[int_user_role] (
    [user_role_id] UNIQUEIDENTIFIER NOT NULL,
    [role_name]    NVARCHAR (32)    NOT NULL,
    [role_desc]    NVARCHAR (255)   NULL,
    CONSTRAINT [PK_int_user_role_user_role_id] PRIMARY KEY CLUSTERED ([user_role_id] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_user_role_role_name]
    ON [dbo].[int_user_role]([role_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to group users into roles. This grouping is only used for security and preferences. Each user in the system must belong to one and only one user role. Users are also grouped by user groups (which is used for clinical grouping such as practicing groups).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_user_role';

