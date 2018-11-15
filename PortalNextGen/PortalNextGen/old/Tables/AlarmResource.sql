CREATE TABLE [old].[AlarmResource] (
    [AlarmResourceID] INT            IDENTITY (1, 1) NOT NULL,
    [EnumGroupID]     INT            NOT NULL,
    [IDEnumValue]     INT            NOT NULL,
    [Label]           NVARCHAR (250) NOT NULL,
    [StrMessage]      NVARCHAR (250) NOT NULL,
    [StrLimitFormat]  NVARCHAR (250) NOT NULL,
    [StrValueFormat]  NVARCHAR (250) NOT NULL,
    [Locale]          VARCHAR (7)    NOT NULL,
    [Message]         NVARCHAR (250) NOT NULL,
    [LimitFormat]     NVARCHAR (250) NOT NULL,
    [ValueFormat]     NVARCHAR (250) NOT NULL,
    [AlarmTypeName]   NVARCHAR (50)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_AlarmResource_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AlarmResource_AlarmResourceID] PRIMARY KEY CLUSTERED ([AlarmResourceID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AlarmResources_Locale_EnumGroupIdIDEnumValue]
    ON [old].[AlarmResource]([Locale] ASC, [EnumGroupID] ASC, [IDEnumValue] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'AlarmResource';

