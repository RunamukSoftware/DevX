﻿CREATE TABLE [dbo].[EmployeeHistory] (
    [EmployeeID]   INT             NOT NULL,
    [Name]         NVARCHAR (100)  NOT NULL,
    [Position]     VARCHAR (100)   NOT NULL,
    [Department]   VARCHAR (100)   NOT NULL,
    [Address]      NVARCHAR (1024) NOT NULL,
    [AnnualSalary] DECIMAL (10, 2) NOT NULL,
    [ValidFrom]    DATETIME2 (2)   NOT NULL,
    [ValidTo]      DATETIME2 (2)   NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_EmployeeHistory]
    ON [dbo].[EmployeeHistory]([ValidTo] ASC, [ValidFrom] ASC);

