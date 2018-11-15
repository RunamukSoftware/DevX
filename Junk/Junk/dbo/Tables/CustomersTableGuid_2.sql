CREATE TABLE [dbo].[CustomersTableGuid] (
    [ID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [FirstName] VARCHAR (50)     NULL,
    [LastName]  VARCHAR (50)     NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

