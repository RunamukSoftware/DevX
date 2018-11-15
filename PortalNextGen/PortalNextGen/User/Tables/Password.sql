CREATE TABLE [User].[Password] (
    [PasswordID]       INT           IDENTITY (1, 1) NOT NULL,
    [UserID]           INT           NOT NULL,
    [Password]         NVARCHAR (40) NOT NULL,
    [CreatedDateTime]  DATETIME2 (7) CONSTRAINT [DF_UserPassword_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedDateTime] DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Password_PasswordID] PRIMARY KEY CLUSTERED ([PasswordID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Password_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_UserPassword_UserID_Password_ModifiedDateTime]
    ON [User].[Password]([UserID] ASC, [Password] ASC, [ModifiedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table contains password history for users whenever they change their password. It is only used if the security option to keep password history has been enabled. It stores previous passwords to prevent users from re-using a password within a certain number of times. The current password for a user is NOT stored in this table (only prior values).', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'Password';

