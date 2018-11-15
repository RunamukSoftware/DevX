CREATE TABLE [User].[User] (
    [UserID]               INT           IDENTITY (1, 1) NOT NULL,
    [RoleID]               INT           NOT NULL,
    [UserSecurityID]       NVARCHAR (68) NOT NULL,
    [HealthCareProviderID] INT           NOT NULL,
    [LoginName]            NVARCHAR (64) NOT NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_User_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedDateTime]     DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_User_UserID] PRIMARY KEY CLUSTERED ([UserID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_User_Role_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [User].[Role] ([RoleID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_User_LoginName]
    ON [User].[User]([LoginName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The table contains an entry for every user of the Intesys products. All Intesys modules that share the common schema will use the same user record regardless of what modules a user has access. Entries in this table are managed by user role administration module in ICS Admin', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'User';

