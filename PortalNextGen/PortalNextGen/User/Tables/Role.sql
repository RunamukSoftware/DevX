CREATE TABLE [User].[Role] (
    [RoleID]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (32)  NOT NULL,
    [Description]      NVARCHAR (255) NULL,
    [CreatedDateTime]  DATETIME2 (7)  CONSTRAINT [DF_Role_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedDateTime] DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Role_RoleID] PRIMARY KEY CLUSTERED ([RoleID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Role_Name]
    ON [User].[Role]([Name] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to group users into roles. This grouping is only used for security and preferences. Each user in the system must belong to one and only one user role. Users are also grouped by user groups (which is used for clinical grouping such as practicing groups).', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'Role';

