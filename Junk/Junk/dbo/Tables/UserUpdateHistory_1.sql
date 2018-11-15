CREATE TABLE [dbo].[UserUpdateHistory] (
    [UserUpdateID] INT            NOT NULL,
    [Description]  VARCHAR (200)  NOT NULL,
    [UserName]     NVARCHAR (128) NOT NULL,
    [ValidFrom]    DATETIME2 (7)  NOT NULL,
    [ValidTo]      DATETIME2 (7)  NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_UserUpdateHistory]
    ON [dbo].[UserUpdateHistory]([ValidTo] ASC, [ValidFrom] ASC);

