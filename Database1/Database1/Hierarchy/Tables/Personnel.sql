CREATE TABLE [Hierarchy].[Personnel] (
    [PersonnelID] INT NOT NULL,
    [ManagerID]   INT NOT NULL,
    [EmployeeID]  INT NOT NULL,
    CONSTRAINT [PK_Personnel_PersonnelID] PRIMARY KEY CLUSTERED ([PersonnelID] ASC),
    CONSTRAINT [FK_Personnel_Employee_EmployeeID] FOREIGN KEY ([EmployeeID]) REFERENCES [Hierarchy].[Employee] ([EmployeeID]),
    CONSTRAINT [FK_Personnel_Employee_ManagerID] FOREIGN KEY ([ManagerID]) REFERENCES [Hierarchy].[Employee] ([EmployeeID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Personnel_EmployeeID]
    ON [Hierarchy].[Personnel]([EmployeeID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Personnel_ManagerID_EmployeeID]
    ON [Hierarchy].[Personnel]([ManagerID] ASC, [EmployeeID] ASC);

