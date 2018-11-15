CREATE TABLE [Intesys].[Preference] (
    [PreferenceID]    INT             IDENTITY (1, 1) NOT NULL,
    [UserID]          INT             NULL,
    [RoleID]          INT             NULL,
    [ApplicationID]   NCHAR (3)       NULL,
    [XmlData]         VARBINARY (MAX) NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_Preference_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Preference_PreferenceID] PRIMARY KEY CLUSTERED ([PreferenceID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Preference_Role_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [User].[Role] ([RoleID]),
    CONSTRAINT [FK_Preference_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Preference_UserID_UserRoleID]
    ON [Intesys].[Preference]([UserID] ASC, [RoleID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores preferences for all users, roles and global. These preferences are stored as an XML string that each application defines. The XML hierarchy allows each application to have a very large number of preferences and to add/remove values without requiring a database change. Preferences are any user configuration values that do NOT deal with security AND are generally available for the user to change. Preferences and security are arranged into a 3-tier hierarchy (Global->Role->User). There is the capability for a lower level to override a higher level. There is also the ability for the higher level to lock down the value (prevent lower-level overrides).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Preference';

