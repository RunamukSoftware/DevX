CREATE TABLE [dbo].[MyDateTime] (
    [MyDateTimeID] INT      IDENTITY (1, 1) NOT NULL,
    [MyDate]       DATE     NOT NULL,
    [MyTime]       TIME (0) NOT NULL,
    CONSTRAINT [PK_MyDateTime] PRIMARY KEY CLUSTERED ([MyDateTimeID] ASC)
);

