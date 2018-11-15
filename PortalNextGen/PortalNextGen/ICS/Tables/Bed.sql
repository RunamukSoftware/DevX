CREATE TABLE [ICS].[Bed] (
    [BedID]           INT           IDENTITY (1, 1) NOT NULL,
    [RoomID]          INT           NOT NULL,
    [Name]            NVARCHAR (50) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Bed_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Bed_BedID] PRIMARY KEY CLUSTERED ([BedID] ASC),
    CONSTRAINT [FK_Bed_Room_RoomID] FOREIGN KEY ([RoomID]) REFERENCES [ICS].[Room] ([RoomID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Bed';

