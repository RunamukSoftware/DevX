CREATE TABLE [dbo].[UserUpdate] (
    [UserUpdateID] INT                                         IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (200)                               NOT NULL,
    [UserName]     NVARCHAR (128)                              CONSTRAINT [DF_UserUpdate_UserName] DEFAULT (suser_name()) NOT NULL,
    [ValidFrom]    DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [ValidTo]      DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_UserUpdate_UserUpdateID] PRIMARY KEY CLUSTERED ([UserUpdateID] ASC),
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo].[UserUpdateHistory], DATA_CONSISTENCY_CHECK=ON));

