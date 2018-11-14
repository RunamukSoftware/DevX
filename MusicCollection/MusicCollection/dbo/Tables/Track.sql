CREATE TABLE [dbo].[Track] (
    [TrackID]     INT            IDENTITY (1, 1) NOT NULL,
    [Title]       NVARCHAR (100)  NOT NULL,
    [RecordingID] INT            NOT NULL,
    [Sequence]    TINYINT        NOT NULL,
    [FileName]    NVARCHAR (260) NULL,
    CONSTRAINT [PK_Track] PRIMARY KEY CLUSTERED ([TrackID] ASC),
    CONSTRAINT [FK_Track_Recording_RecordingID] FOREIGN KEY ([RecordingID]) REFERENCES [dbo].[Recording] ([RecordingID])
);

