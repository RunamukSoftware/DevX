CREATE TABLE [ICS].[Room] (
    [RoomID]          INT           IDENTITY (1, 1) NOT NULL,
    [FacilityID]      INT           NOT NULL,
    [Name]            NVARCHAR (50) NOT NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_Room_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Room_RoomID] PRIMARY KEY CLUSTERED ([RoomID] ASC),
    CONSTRAINT [FK_Room_Facility_FacilityID] FOREIGN KEY ([FacilityID]) REFERENCES [ICS].[Facility] ([FacilityID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'ICS', @level1type = N'TABLE', @level1name = N'Room';

