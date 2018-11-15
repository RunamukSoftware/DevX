CREATE TABLE [dbo].[DepartmentHistory] (
    [DeptID]          INT           NOT NULL,
    [DeptName]        VARCHAR (50)  NOT NULL,
    [ManagerID]       INT           NULL,
    [ParentDeptID]    INT           NULL,
    [SystemStartTime] DATETIME2 (7) NOT NULL,
    [SystemEndTime]   DATETIME2 (7) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_DepartmentHistory_SystemEndTime_SystemStartTime_DeptID]
    ON [dbo].[DepartmentHistory]([SystemEndTime] ASC, [SystemStartTime] ASC, [DeptID] ASC);


GO
CREATE CLUSTERED COLUMNSTORE INDEX [CL_DepartmentHistory_ColumnStore]
    ON [dbo].[DepartmentHistory];

