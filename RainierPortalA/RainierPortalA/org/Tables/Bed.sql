CREATE TABLE [org].[Bed] (
    [BedID]           INT           IDENTITY (1, 1) NOT NULL,
    [RoomID]          INT           NOT NULL,
    [Name]            VARCHAR (50)  NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Bed_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Bed_BedID] PRIMARY KEY CLUSTERED ([BedID] ASC),
    CONSTRAINT [FK_Bed_Room_RoomID] FOREIGN KEY ([RoomID]) REFERENCES [org].[Room] ([RoomID])
);

