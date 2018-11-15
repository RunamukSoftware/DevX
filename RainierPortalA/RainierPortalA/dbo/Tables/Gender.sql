CREATE TABLE [dbo].[Gender] (
    [GenderID]        TINYINT       IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (50)  DEFAULT ('') NOT NULL,
    [CreatedDateTime] DATETIME2 (7) DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Gender_GenderID] PRIMARY KEY CLUSTERED ([GenderID] ASC) WITH (FILLFACTOR = 100)
);

