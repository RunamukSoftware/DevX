CREATE TABLE [dbo].[AlarmResources] (
    [EnumGroupId]    UNIQUEIDENTIFIER NULL,
    [IDEnumValue]    INT              NULL,
    [Label]          NVARCHAR (250)   NULL,
    [StrMessage]     NVARCHAR (250)   NULL,
    [StrLimitFormat] NVARCHAR (250)   NULL,
    [StrValueFormat] NVARCHAR (250)   NULL,
    [Locale]         VARCHAR (7)      NULL,
    [Message]        NVARCHAR (250)   NULL,
    [LimitFormat]    NVARCHAR (250)   NULL,
    [ValueFormat]    NVARCHAR (250)   NULL,
    [AlarmTypeName]  NVARCHAR (50)    NULL,
    [CreatedDateTime] DATETIME2(7) NOT NULL CONSTRAINT [DF_AlarmResources_CreatedDateTime] DEFAULT (SYSUTCDATETIME())
);
GO
CREATE UNIQUE CLUSTERED INDEX [CL_AlarmResources_Locale_EnumGroupId_IDEnumValue]
    ON [dbo].[AlarmResources]([Locale] ASC, [EnumGroupId] ASC, [IDEnumValue] ASC) WITH (FILLFACTOR = 100);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AlarmResources';
