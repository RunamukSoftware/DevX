CREATE TABLE [dbo].[JsonTable] (
    [JsonTableID] INT            IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (255)  NOT NULL,
    [Description] VARCHAR (1024) NOT NULL,
    [JsonData]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_JsonTable_JsonTableID] PRIMARY KEY CLUSTERED ([JsonTableID] ASC)
);

