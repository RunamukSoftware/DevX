CREATE TABLE [dbo].[Dvd]
    ([DVD_Title] NVARCHAR(200) NOT NULL,
     [Studio] NVARCHAR(200) NOT NULL,
     [Released] NVARCHAR(50) NULL,
     [Status] NVARCHAR(50) NOT NULL,
     [Sound] NVARCHAR(50) NOT NULL,
     [Versions] NVARCHAR(50) NOT NULL,
     [Price] NVARCHAR(50) NOT NULL,
     [Rating] NVARCHAR(50) NOT NULL,
     [Year] NVARCHAR(50) NOT NULL,
     [Genre] NVARCHAR(50) NOT NULL,
     [Aspect] NVARCHAR(50) NOT NULL,
     [UPC] NVARCHAR(50) NULL,
     [DVD_ReleaseDate] SMALLDATETIME NULL,
     [DvdID] INT NOT NULL IDENTITY(1, 1),
     [Timestamp] SMALLDATETIME NOT NULL);

