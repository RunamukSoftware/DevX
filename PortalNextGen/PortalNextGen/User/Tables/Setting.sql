CREATE TABLE [User].[Setting] (
    [SettingID]             INT           IDENTITY (1, 1) NOT NULL,
    [UserID]                INT           NOT NULL,
    [ConfigurationName]     VARCHAR (40)  NOT NULL,
    [ConfigurationXmlValue] XML           NOT NULL,
    [CreatedDateTime]       DATETIME2 (7) CONSTRAINT [DF_UserSetting_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedDateTime]      DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_Setting_SettingID] PRIMARY KEY CLUSTERED ([SettingID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Setting_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [User].[User] ([UserID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Setting_UserID_ConfigurationName]
    ON [User].[Setting]([UserID] ASC, [ConfigurationName] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Old Intesys user settings table.', @level0type = N'SCHEMA', @level0name = N'User', @level1type = N'TABLE', @level1name = N'Setting';

