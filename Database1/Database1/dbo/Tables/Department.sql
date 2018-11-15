CREATE TABLE [dbo].[Department] (
    [DeptID]          INT                                         NOT NULL,
    [DeptName]        VARCHAR (50)                                NOT NULL,
    [ManagerID]       INT                                         NULL,
    [ParentDeptID]    INT                                         NULL,
    [SystemStartTime] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [SystemEndTime]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    PRIMARY KEY CLUSTERED ([DeptID] ASC),
    PERIOD FOR SYSTEM_TIME ([SystemStartTime], [SystemEndTime])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo].[DepartmentHistory], DATA_CONSISTENCY_CHECK=ON));

