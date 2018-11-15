CREATE TABLE [dbo].[int_user] (
    [user_id]      UNIQUEIDENTIFIER NOT NULL,
    [user_role_id] UNIQUEIDENTIFIER NOT NULL,
    [user_sid]     NVARCHAR (68)    NULL,
    [hcp_id]       UNIQUEIDENTIFIER NULL,
    [login_name]   NVARCHAR (64)    NULL,
    CONSTRAINT [PK_int_user_user_id] PRIMARY KEY CLUSTERED ([user_id] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_int_user_login_name]
    ON [dbo].[int_user]([login_name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The table contains an entry for every user of the Intesys products. All Intesys modules that share the common schema will use the same user record regardless of what modules a user has access. Entries in this table are managed by user role administration module in ICS Admin', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_user';

