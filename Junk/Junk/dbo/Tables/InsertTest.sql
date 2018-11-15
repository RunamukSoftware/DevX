CREATE TABLE [dbo].[InsertTest] (
    [InsertTestID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (255) NOT NULL,
    [Value]        INT           NOT NULL,
    CONSTRAINT [PK_InsertTest_InsertTestID] PRIMARY KEY CLUSTERED ([InsertTestID] ASC)
);

