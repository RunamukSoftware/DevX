CREATE TABLE [dbo].[CustomersTableIdent] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [FirstName] VARCHAR (50) NULL,
    [LastName]  VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

