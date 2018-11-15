CREATE TABLE [dbo].[Artist] (
    [ArtistID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Artist] PRIMARY KEY CLUSTERED ([ArtistID] ASC)
);

