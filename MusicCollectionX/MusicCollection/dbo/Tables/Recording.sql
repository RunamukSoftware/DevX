CREATE TABLE [dbo].[Recording] (
    [RecordingID] INT          IDENTITY (1, 1) NOT NULL,
    [ArtistID]    INT          NOT NULL,
    [Title]       NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_Recording] PRIMARY KEY CLUSTERED ([RecordingID] ASC),
    CONSTRAINT [FK_Recording_Artist_ArtistID] FOREIGN KEY ([ArtistID]) REFERENCES [dbo].[Artist] ([ArtistID])
);

