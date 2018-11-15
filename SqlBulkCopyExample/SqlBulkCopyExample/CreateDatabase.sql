USE [master];

IF EXISTS ( SELECT
                [name]
            FROM
                [sys].[databases]
            WHERE
                [name] = N'MostWanted' )
BEGIN
    ALTER DATABASE [MostWanted] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [MostWanted];
END;

CREATE DATABASE [MostWanted];

USE [MostWanted];

CREATE TABLE [dbo].[Person]
    (
     [PersonId] [INT] IDENTITY(1, 1)
                      NOT NULL,
     [Name] [NVARCHAR](100) NOT NULL,
     [DateOfBirth] [DATETIME] NULL,
     CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC)
    );
