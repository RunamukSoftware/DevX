CREATE TABLE [#temptable]
    ([ArtistID] INT,
     [Name] NVARCHAR(100));

INSERT INTO [#temptable]
VALUES (
       1, N'Genesis'
       ),
       (
       2, N'Rush'
       ),
       (
       3, N'Elvis Presley'
       ),
       (
       4, N'Arianna Grande'
       );

DROP TABLE [#temptable];
GO
