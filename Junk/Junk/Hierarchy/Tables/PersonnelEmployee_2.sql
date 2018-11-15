CREATE TABLE [Hierarchy].[PersonnelEmployee] (
    [PersonnelEmployeeID] INT           IDENTITY (1, 1) NOT NULL,
    [ManagerID]           INT           NOT NULL,
    [FirstName]           VARCHAR (50)  NOT NULL,
    [LastName]            VARCHAR (50)  NOT NULL,
    [CreatedDateTime]     DATETIME2 (7) CONSTRAINT [DF_PersonnelEmployee_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PersonnelEmployee_PersonnelID] PRIMARY KEY CLUSTERED ([PersonnelEmployeeID] ASC),
    CONSTRAINT [FK_PersonnelEmployee_PersonnelEmployee_ManagerID] FOREIGN KEY ([ManagerID]) REFERENCES [Hierarchy].[PersonnelEmployee] ([PersonnelEmployeeID])
);

