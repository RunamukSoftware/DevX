﻿CREATE TABLE [Intesys].[PreferenceDifference] (
    [PreferenceDifferenceID] INT            IDENTITY (1, 1) NOT NULL,
    [UserID]                 INT            NULL,
    [RoleID]                 INT            NULL,
    [NodePath]               NVARCHAR (255) NOT NULL,
    [ChangedAtGlobal]        TINYINT        NULL,
    [CreatedDateTime]        DATETIME2 (7)  CONSTRAINT [DF_PreferenceDifference_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PreferenceDifference_PreferenceDifferenceID] PRIMARY KEY CLUSTERED ([PreferenceDifferenceID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PreferenceDifference_Role_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [User].[Role] ([RoleID]),
    CONSTRAINT [FK_PreferenceDifference_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PreferenceDifference_UserRoleID_NodePath_UserID_ChangedAtGlobal]
    ON [Intesys].[PreferenceDifference]([RoleID] ASC, [NodePath] ASC, [UserID] ASC, [ChangedAtGlobal] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table defines "Differences" that occur when a lower-level value is changed. This only occurs when a user or role value is changed. It is used to quickly display a change indicator at the global or role level if a lower-level value is different from the higher-level value. These records are only removed if a push-down is applied for a specific level in the XML.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PreferenceDifference';

