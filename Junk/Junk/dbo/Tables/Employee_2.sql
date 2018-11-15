CREATE TABLE [dbo].[Employee] (
    [EmployeeID]   INT                                         NOT NULL,
    [Name]         NVARCHAR (100)                              NOT NULL,
    [Position]     VARCHAR (100)                               NOT NULL,
    [Department]   VARCHAR (100)                               NOT NULL,
    [Address]      NVARCHAR (1024)                             NOT NULL,
    [AnnualSalary] DECIMAL (10, 2)                             NOT NULL,
    [ValidFrom]    DATETIME2 (2) GENERATED ALWAYS AS ROW START NOT NULL,
    [ValidTo]      DATETIME2 (2) GENERATED ALWAYS AS ROW END   NOT NULL,
    PRIMARY KEY CLUSTERED ([EmployeeID] ASC),
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo].[EmployeeHistory], DATA_CONSISTENCY_CHECK=ON));

