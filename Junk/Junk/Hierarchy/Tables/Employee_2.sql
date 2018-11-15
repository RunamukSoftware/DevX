CREATE TABLE [Hierarchy].[Employee] (
    [EmployeeID] INT          NOT NULL,
    [FirstName]  VARCHAR (50) NOT NULL,
    [LastName]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Employee_EmployeeID] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);

