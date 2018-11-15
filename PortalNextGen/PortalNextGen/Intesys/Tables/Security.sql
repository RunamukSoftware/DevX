CREATE TABLE [Intesys].[Security] (
    [SecurityID]      INT           IDENTITY (1, 1) NOT NULL,
    [UserID]          INT           NOT NULL,
    [RoleID]          INT           NOT NULL,
    [ApplicationID]   NCHAR (3)     NOT NULL,
    [XmlData]         XML           NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Security_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Security_SecurityID] PRIMARY KEY CLUSTERED ([SecurityID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Security_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Security_UserID_RoleID]
    ON [Intesys].[Security]([UserID] ASC, [RoleID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores security settings for all users, roles and global. These security settings are stored as an XML string that each application defines. The XML hierarchy allows each application to have a very large number of security settings and to add/remove values without requiring a database change. Security settings are any setting that controls access to data and/or applications that are defined and controlled by administrators. Preferences and security are arranged into a 3-tier hierarchy (Global->Role->User). There is the capability for a lower level to override a higher level. There is also the ability for the higher level to lock down the value (prevent lower-level overrides).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Security';

