CREATE TABLE [old].[ApplicationSetting] (
    [ApplicationSettingID] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [ApplicationType]      VARCHAR (50)   NOT NULL,
    [InstanceID]           VARCHAR (50)   NOT NULL,
    [Key]                  VARCHAR (50)   NOT NULL,
    [Value]                VARCHAR (5000) NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_ApplicationSetting_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_ApplicationSetting_ApplicationSettingID] PRIMARY KEY CLUSTERED ([ApplicationSettingID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Application settings', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'ApplicationSetting';

