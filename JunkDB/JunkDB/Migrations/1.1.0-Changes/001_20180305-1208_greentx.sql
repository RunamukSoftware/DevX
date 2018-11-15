-- <Migration ID="03ce85bf-3a0a-461f-9913-15b48a30a9b1" TransactionHandling="Custom" />
GO

/*
	NOTE: This script contains additional logic due to the inclusion of memory-optimized tables or full-text objects:
	      As this script will run without any transaction handling (a SQL Server requirement for Full Text deployments),
		  all statements must be wrapped in IF NOT EXISTS... blocks to ensure that the entire script can be re-run,
		  in the event that a depoyment failure occurs on the first attempt.
		  To re-generate this script without the additional logic:
		  (1) Delete this script from the project
		  (2) In the ReadyRoll tool, click "Refresh" to view pending changes
		  (3) Un-check all Full Text related objects
		  (4) Click "Import and generate script"
		  The script should be generated without the IF NOT EXISTS... blocks.
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
GO
IF SCHEMA_ID(N'Hierarchy') IS NULL
EXEC sp_executesql N'CREATE SCHEMA [Hierarchy]
AUTHORIZATION [dbo]'
GO
PRINT N'Dropping constraints from [dbo].[PivotTest]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_PivotTest]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[PivotTest]', 'U'))
ALTER TABLE [dbo].[PivotTest] DROP CONSTRAINT [PK_PivotTest]
GO
PRINT N'Dropping constraints from [dbo].[T1]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_dbo_T1]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[T1]', 'U'))
ALTER TABLE [dbo].[T1] DROP CONSTRAINT [PK_dbo_T1]
GO
PRINT N'Dropping constraints from [dbo].[T2]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_dbo_T2]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[T2]', 'U'))
ALTER TABLE [dbo].[T2] DROP CONSTRAINT [PK_dbo_T2]
GO
PRINT N'Dropping index [CIX_BillionNumber_Number] from [dbo].[BillionNumber]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'CIX_BillionNumber_Number' AND object_id = OBJECT_ID(N'[dbo].[BillionNumber]'))
DROP INDEX [CIX_BillionNumber_Number] ON [dbo].[BillionNumber]
GO
PRINT N'Dropping index [CX_Example_SomeID_StartDate] from [dbo].[Example]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'CX_Example_SomeID_StartDate' AND object_id = OBJECT_ID(N'[dbo].[Example]'))
DROP INDEX [CX_Example_SomeID_StartDate] ON [dbo].[Example]
GO
PRINT N'Dropping index [CIX_Number] from [dbo].[MillionNumber]'
GO
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'CIX_Number' AND object_id = OBJECT_ID(N'[dbo].[MillionNumber]'))
DROP INDEX [CIX_Number] ON [dbo].[MillionNumber]
GO
PRINT N'Dropping [dbo].[T2]'
GO
IF OBJECT_ID(N'[dbo].[T2]', 'U') IS NOT NULL
DROP TABLE [dbo].[T2]
GO
PRINT N'Dropping [dbo].[T1]'
GO
IF OBJECT_ID(N'[dbo].[T1]', 'U') IS NOT NULL
DROP TABLE [dbo].[T1]
GO
PRINT N'Dropping [dbo].[PivotTest]'
GO
IF OBJECT_ID(N'[dbo].[PivotTest]', 'U') IS NOT NULL
DROP TABLE [dbo].[PivotTest]
GO
PRINT N'Dropping [dbo].[MillionNumber]'
GO
IF OBJECT_ID(N'[dbo].[MillionNumber]', 'U') IS NOT NULL
DROP TABLE [dbo].[MillionNumber]
GO
PRINT N'Dropping [dbo].[LastName]'
GO
IF OBJECT_ID(N'[dbo].[LastName]', 'U') IS NOT NULL
DROP TABLE [dbo].[LastName]
GO
PRINT N'Dropping [dbo].[FirstName]'
GO
IF OBJECT_ID(N'[dbo].[FirstName]', 'U') IS NOT NULL
DROP TABLE [dbo].[FirstName]
GO
PRINT N'Dropping [dbo].[Example]'
GO
IF OBJECT_ID(N'[dbo].[Example]', 'U') IS NOT NULL
DROP TABLE [dbo].[Example]
GO
PRINT N'Dropping [dbo].[BillionNumber]'
GO
IF OBJECT_ID(N'[dbo].[BillionNumber]', 'U') IS NOT NULL
DROP TABLE [dbo].[BillionNumber]
GO
PRINT N'Creating [dbo].[UserUpdate]'
GO
IF OBJECT_ID(N'[dbo].[UserUpdateHistory]', 'U') IS NULL
CREATE TABLE [dbo].[UserUpdateHistory]
(
[UserUpdateID] [int] NOT NULL,
[Description] [varchar] (200) NOT NULL,
[UserName] [nvarchar] (128) NOT NULL,
[ValidFrom] [datetime2] NOT NULL,
[ValidTo] [datetime2] NOT NULL
)
GO
PRINT N'Creating index [ix_UserUpdateHistory] on [dbo].[UserUpdateHistory]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_UserUpdateHistory' AND object_id = OBJECT_ID(N'[dbo].[UserUpdateHistory]'))
CREATE CLUSTERED INDEX [ix_UserUpdateHistory] ON [dbo].[UserUpdateHistory] ([ValidTo], [ValidFrom])
GO
IF OBJECT_ID(N'[dbo].[UserUpdate]', 'U') IS NULL
CREATE TABLE [dbo].[UserUpdate]
(
[UserUpdateID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (200) NOT NULL,
[UserName] [nvarchar] (128) NOT NULL CONSTRAINT [DF_UserUpdate_UserName] DEFAULT (suser_name()),
[ValidFrom] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK_UserUpdate_UserUpdateID] PRIMARY KEY CLUSTERED  ([UserUpdateID])
)
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[UserUpdateHistory])
)
GO
PRINT N'Creating [dbo].[CustomersTableGuid]'
GO
IF OBJECT_ID(N'[dbo].[CustomersTableGuid]', 'U') IS NULL
CREATE TABLE [dbo].[CustomersTableGuid]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__CustomersTab__ID__3C34F16F] DEFAULT (newid()),
[FirstName] [varchar] (50) NULL,
[LastName] [varchar] (50) NULL
)
GO
PRINT N'Creating primary key [PK__Customer__3214EC27FBA27FFC] on [dbo].[CustomersTableGuid]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK__Customer__3214EC27FBA27FFC' AND object_id = OBJECT_ID(N'[dbo].[CustomersTableGuid]'))
ALTER TABLE [dbo].[CustomersTableGuid] ADD CONSTRAINT [PK__Customer__3214EC27FBA27FFC] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [Hierarchy].[PersonnelEmployee]'
GO
IF OBJECT_ID(N'[Hierarchy].[PersonnelEmployee]', 'U') IS NULL
CREATE TABLE [Hierarchy].[PersonnelEmployee]
(
[PersonnelEmployeeID] [int] NOT NULL IDENTITY(1, 1),
[ManagerID] [int] NOT NULL,
[FirstName] [varchar] (50) NOT NULL,
[LastName] [varchar] (50) NOT NULL,
[CreatedDateTime] [datetime2] NOT NULL CONSTRAINT [DF_PersonnelEmployee_CreatedDateTime] DEFAULT (sysutcdatetime())
)
GO
PRINT N'Creating primary key [PK_PersonnelEmployee_PersonnelID] on [Hierarchy].[PersonnelEmployee]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_PersonnelEmployee_PersonnelID' AND object_id = OBJECT_ID(N'[Hierarchy].[PersonnelEmployee]'))
ALTER TABLE [Hierarchy].[PersonnelEmployee] ADD CONSTRAINT [PK_PersonnelEmployee_PersonnelID] PRIMARY KEY CLUSTERED  ([PersonnelEmployeeID])
GO
PRINT N'Creating [Hierarchy].[Employee]'
GO
IF OBJECT_ID(N'[Hierarchy].[Employee]', 'U') IS NULL
CREATE TABLE [Hierarchy].[Employee]
(
[EmployeeID] [int] NOT NULL,
[FirstName] [varchar] (50) NOT NULL,
[LastName] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_Employee_EmployeeID] on [Hierarchy].[Employee]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_Employee_EmployeeID' AND object_id = OBJECT_ID(N'[Hierarchy].[Employee]'))
ALTER TABLE [Hierarchy].[Employee] ADD CONSTRAINT [PK_Employee_EmployeeID] PRIMARY KEY CLUSTERED  ([EmployeeID])
GO
PRINT N'Creating [Hierarchy].[Personnel]'
GO
IF OBJECT_ID(N'[Hierarchy].[Personnel]', 'U') IS NULL
CREATE TABLE [Hierarchy].[Personnel]
(
[PersonnelID] [int] NOT NULL,
[ManagerID] [int] NOT NULL,
[EmployeeID] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_Personnel_PersonnelID] on [Hierarchy].[Personnel]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_Personnel_PersonnelID' AND object_id = OBJECT_ID(N'[Hierarchy].[Personnel]'))
ALTER TABLE [Hierarchy].[Personnel] ADD CONSTRAINT [PK_Personnel_PersonnelID] PRIMARY KEY CLUSTERED  ([PersonnelID])
GO
PRINT N'Creating index [IX_Personnel_EmployeeID] on [Hierarchy].[Personnel]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Personnel_EmployeeID' AND object_id = OBJECT_ID(N'[Hierarchy].[Personnel]'))
CREATE UNIQUE NONCLUSTERED INDEX [IX_Personnel_EmployeeID] ON [Hierarchy].[Personnel] ([EmployeeID])
GO
PRINT N'Creating index [IX_Personnel_ManagerID_EmployeeID] on [Hierarchy].[Personnel]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Personnel_ManagerID_EmployeeID' AND object_id = OBJECT_ID(N'[Hierarchy].[Personnel]'))
CREATE UNIQUE NONCLUSTERED INDEX [IX_Personnel_ManagerID_EmployeeID] ON [Hierarchy].[Personnel] ([ManagerID], [EmployeeID])
GO
PRINT N'Creating [dbo].[CustomersTableIdent]'
GO
IF OBJECT_ID(N'[dbo].[CustomersTableIdent]', 'U') IS NULL
CREATE TABLE [dbo].[CustomersTableIdent]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [varchar] (50) NULL,
[LastName] [varchar] (50) NULL
)
GO
PRINT N'Creating primary key [PK__Customer__3214EC27F3FD6990] on [dbo].[CustomersTableIdent]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK__Customer__3214EC27F3FD6990' AND object_id = OBJECT_ID(N'[dbo].[CustomersTableIdent]'))
ALTER TABLE [dbo].[CustomersTableIdent] ADD CONSTRAINT [PK__Customer__3214EC27F3FD6990] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[DateDimension]'
GO
IF OBJECT_ID(N'[dbo].[DateDimension]', 'U') IS NULL
CREATE TABLE [dbo].[DateDimension]
(
[DateKey] [int] NOT NULL,
[Date] [date] NOT NULL,
[Day] [tinyint] NOT NULL,
[DaySuffix] [char] (2) NOT NULL,
[Weekday] [tinyint] NOT NULL,
[WeekDayName] [varchar] (10) NOT NULL,
[IsWeekend] [bit] NOT NULL,
[IsHoliday] [bit] NOT NULL,
[HolidayText] [varchar] (64) NULL,
[DOWInMonth] [tinyint] NOT NULL,
[DayOfYear] [smallint] NOT NULL,
[WeekOfMonth] [tinyint] NOT NULL,
[WeekOfYear] [tinyint] NOT NULL,
[ISOWeekOfYear] [tinyint] NOT NULL,
[Month] [tinyint] NOT NULL,
[MonthName] [varchar] (10) NOT NULL,
[Quarter] [tinyint] NOT NULL,
[QuarterName] [varchar] (6) NOT NULL,
[Year] [int] NOT NULL,
[MMYYYY] [char] (6) NOT NULL,
[MonthYear] [char] (7) NOT NULL,
[FirstDayOfMonth] [date] NOT NULL,
[LastDayOfMonth] [date] NOT NULL,
[FirstDayOfQuarter] [date] NOT NULL,
[LastDayOfQuarter] [date] NOT NULL,
[FirstDayOfYear] [date] NOT NULL,
[LastDayOfYear] [date] NOT NULL,
[FirstDayOfNextMonth] [date] NOT NULL,
[FirstDayOfNextYear] [date] NOT NULL
)
GO
PRINT N'Creating [dbo].[Department]'
GO
IF OBJECT_ID(N'[dbo].[DepartmentHistory]', 'U') IS NULL
CREATE TABLE [dbo].[DepartmentHistory]
(
[DeptID] [int] NOT NULL,
[DeptName] [varchar] (50) NOT NULL,
[ManagerID] [int] NULL,
[ParentDeptID] [int] NULL,
[SystemStartTime] [datetime2] NOT NULL,
[SystemEndTime] [datetime2] NOT NULL
)
GO
PRINT N'Creating index [CL_DepartmentHistory_ColumnStore] on [dbo].[DepartmentHistory]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'CL_DepartmentHistory_ColumnStore' AND object_id = OBJECT_ID(N'[dbo].[DepartmentHistory]'))
CREATE CLUSTERED COLUMNSTORE INDEX [CL_DepartmentHistory_ColumnStore] ON [dbo].[DepartmentHistory]
GO
IF OBJECT_ID(N'[dbo].[Department]', 'U') IS NULL
CREATE TABLE [dbo].[Department]
(
[DeptID] [int] NOT NULL,
[DeptName] [varchar] (50) NOT NULL,
[ManagerID] [int] NULL,
[ParentDeptID] [int] NULL,
[SystemStartTime] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[SystemEndTime] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (SystemStartTime, SystemEndTime),
CONSTRAINT [PK__Departme__0148818E65270BDB] PRIMARY KEY CLUSTERED  ([DeptID])
)
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[DepartmentHistory])
)
GO
PRINT N'Creating [dbo].[DiskStall]'
GO
IF OBJECT_ID(N'[dbo].[DiskStall]', 'U') IS NULL
CREATE TABLE [dbo].[DiskStall]
(
[ID] [bigint] NOT NULL,
[ServerName] [nvarchar] (128) NULL,
[InstanceName] [nvarchar] (128) NULL,
[DatabaseID] [smallint] NOT NULL,
[DatabaseName] [nvarchar] (128) NOT NULL,
[PhysicalFileName] [nvarchar] (260) NOT NULL,
[DatabaseFileID] [int] NOT NULL,
[AvgReadStallms] [numeric] (10, 1) NULL,
[AvgWriteStallms] [numeric] (10, 1) NULL,
[IOStallReadms] [bigint] NULL,
[NumOfReads] [bigint] NULL,
[IOStallWritems] [bigint] NULL,
[NumOfWrites] [bigint] NULL,
[TotalNumOfBytesRead] [bigint] NULL,
[TotalNumOfBytesWritten] [bigint] NULL,
[CollectionDateTime] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_DiskStall_ID] on [dbo].[DiskStall]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_DiskStall_ID' AND object_id = OBJECT_ID(N'[dbo].[DiskStall]'))
ALTER TABLE [dbo].[DiskStall] ADD CONSTRAINT [PK_DiskStall_ID] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[EmployeeHidden]'
GO
IF OBJECT_ID(N'[dbo].[EmployeeHistoryHidden]', 'U') IS NULL
CREATE TABLE [dbo].[EmployeeHistoryHidden]
(
[EmployeeID] [int] NOT NULL,
[Name] [nvarchar] (100) NOT NULL,
[Position] [varchar] (100) NOT NULL,
[Department] [varchar] (100) NOT NULL,
[Address] [nvarchar] (1024) NOT NULL,
[AnnualSalary] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] (2) NOT NULL,
[ValidTo] [datetime2] (2) NOT NULL
)
GO
PRINT N'Creating index [ix_EmployeeHistoryHidden] on [dbo].[EmployeeHistoryHidden]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_EmployeeHistoryHidden' AND object_id = OBJECT_ID(N'[dbo].[EmployeeHistoryHidden]'))
CREATE CLUSTERED INDEX [ix_EmployeeHistoryHidden] ON [dbo].[EmployeeHistoryHidden] ([ValidTo], [ValidFrom])
GO
IF OBJECT_ID(N'[dbo].[EmployeeHidden]', 'U') IS NULL
CREATE TABLE [dbo].[EmployeeHidden]
(
[EmployeeID] [int] NOT NULL,
[Name] [nvarchar] (100) NOT NULL,
[Position] [varchar] (100) NOT NULL,
[Department] [varchar] (100) NOT NULL,
[Address] [nvarchar] (1024) NOT NULL,
[AnnualSalary] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] (2) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
[ValidTo] [datetime2] (2) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK__Employee__7AD04FF19F9C6E89] PRIMARY KEY CLUSTERED  ([EmployeeID])
)
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[EmployeeHistoryHidden])
)
GO
PRINT N'Creating [dbo].[Employee]'
GO
IF OBJECT_ID(N'[dbo].[EmployeeHistory]', 'U') IS NULL
CREATE TABLE [dbo].[EmployeeHistory]
(
[EmployeeID] [int] NOT NULL,
[Name] [nvarchar] (100) NOT NULL,
[Position] [varchar] (100) NOT NULL,
[Department] [varchar] (100) NOT NULL,
[Address] [nvarchar] (1024) NOT NULL,
[AnnualSalary] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] (2) NOT NULL,
[ValidTo] [datetime2] (2) NOT NULL
)
GO
PRINT N'Creating index [ix_EmployeeHistory] on [dbo].[EmployeeHistory]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'ix_EmployeeHistory' AND object_id = OBJECT_ID(N'[dbo].[EmployeeHistory]'))
CREATE CLUSTERED INDEX [ix_EmployeeHistory] ON [dbo].[EmployeeHistory] ([ValidTo], [ValidFrom])
GO
IF OBJECT_ID(N'[dbo].[Employee]', 'U') IS NULL
CREATE TABLE [dbo].[Employee]
(
[EmployeeID] [int] NOT NULL,
[Name] [nvarchar] (100) NOT NULL,
[Position] [varchar] (100) NOT NULL,
[Department] [varchar] (100) NOT NULL,
[Address] [nvarchar] (1024) NOT NULL,
[AnnualSalary] [decimal] (10, 2) NOT NULL,
[ValidFrom] [datetime2] (2) GENERATED ALWAYS AS ROW START NOT NULL,
[ValidTo] [datetime2] (2) GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo),
CONSTRAINT [PK__Employee__7AD04FF17BA17C8A] PRIMARY KEY CLUSTERED  ([EmployeeID])
)
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[EmployeeHistory])
)
GO
PRINT N'Creating [dbo].[GeneralAlarmsData]'
GO
IF OBJECT_ID(N'[dbo].[GeneralAlarmsData]', 'U') IS NULL
CREATE TABLE [dbo].[GeneralAlarmsData]
(
[Column01] [uniqueidentifier] NOT NULL,
[Column02] [tinyint] NULL,
[Column03] [datetime] NOT NULL,
[Column04] [datetime] NULL,
[Column05] [int] NOT NULL,
[Column06] [int] NOT NULL,
[Column07] [datetime] NOT NULL,
[Column08] [int] NOT NULL,
[Column09] [uniqueidentifier] NOT NULL,
[Column10] [uniqueidentifier] NOT NULL,
[Column11] [uniqueidentifier] NOT NULL,
[Column12] [int] NOT NULL,
[Column13] [uniqueidentifier] NOT NULL,
[Column14] [bigint] NOT NULL,
[Column15] [datetime2] NOT NULL
)
GO
PRINT N'Creating [dbo].[HL7Queries]'
GO
IF OBJECT_ID(N'[dbo].[HL7Queries]', 'U') IS NULL
CREATE TABLE [dbo].[HL7Queries]
(
[_name_] [nvarchar] (50) NOT NULL,
[_timestamp_] [nvarchar] (50) NOT NULL,
[_timestamp__UTC__] [nvarchar] (50) NOT NULL,
[_cpu_time_] [nvarchar] (50) NOT NULL,
[_duration_] [nvarchar] (50) NOT NULL,
[_physical_reads_] [nvarchar] (50) NOT NULL,
[_logical_reads_] [nvarchar] (50) NOT NULL,
[_writes_] [nvarchar] (50) NOT NULL,
[_result_] [nvarchar] (50) NOT NULL,
[_row_count_] [nvarchar] (50) NOT NULL,
[_connection_reset_option_] [nvarchar] (50) NOT NULL,
[_object_name_] [nvarchar] (50) NOT NULL,
[_statement_] [nvarchar] (max) NOT NULL,
[_data_stream_] [nvarchar] (max) NOT NULL,
[_output_parameters_] [nvarchar] (50) NOT NULL,
[_database_name_] [nvarchar] (50) NOT NULL,
[_database_id_] [nvarchar] (50) NOT NULL,
[_client_hostname_] [nvarchar] (50) NOT NULL,
[_client_app_name_] [nvarchar] (50) NOT NULL,
[_sql_text_] [nvarchar] (max) NOT NULL
)
GO
PRINT N'Creating [dbo].[JsonTable]'
GO
IF OBJECT_ID(N'[dbo].[JsonTable]', 'U') IS NULL
CREATE TABLE [dbo].[JsonTable]
(
[JsonTableID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) NOT NULL,
[Description] [varchar] (1024) NOT NULL,
[JsonData] [nvarchar] (max) NOT NULL
)
GO
PRINT N'Creating primary key [PK_JsonTable_JsonTableID] on [dbo].[JsonTable]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_JsonTable_JsonTableID' AND object_id = OBJECT_ID(N'[dbo].[JsonTable]'))
ALTER TABLE [dbo].[JsonTable] ADD CONSTRAINT [PK_JsonTable_JsonTableID] PRIMARY KEY CLUSTERED  ([JsonTableID])
GO
PRINT N'Creating [dbo].[MyDateTime]'
GO
IF OBJECT_ID(N'[dbo].[MyDateTime]', 'U') IS NULL
CREATE TABLE [dbo].[MyDateTime]
(
[MyDateTimeID] [int] NOT NULL IDENTITY(1, 1),
[MyDate] [date] NOT NULL,
[MyTime] [time] (0) NOT NULL
)
GO
PRINT N'Creating primary key [PK_MyDateTime] on [dbo].[MyDateTime]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_MyDateTime' AND object_id = OBJECT_ID(N'[dbo].[MyDateTime]'))
ALTER TABLE [dbo].[MyDateTime] ADD CONSTRAINT [PK_MyDateTime] PRIMARY KEY CLUSTERED  ([MyDateTimeID])
GO
PRINT N'Creating [dbo].[Number]'
GO
IF OBJECT_ID(N'[dbo].[Number]', 'U') IS NULL
CREATE TABLE [dbo].[Number]
(
[Value] [int] NOT NULL
)
GO
PRINT N'Creating [dbo].[Organization]'
GO
IF OBJECT_ID(N'[dbo].[Organization]', 'U') IS NULL
CREATE TABLE [dbo].[Organization]
(
[OrganizationID] [int] NOT NULL,
[OrganizationNumber] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OrganizationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ManagerID] [int] NULL,
[ParentOrganizationNumber] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
CONSTRAINT [PK_Organization_OrganizationID] PRIMARY KEY NONCLUSTERED  ([OrganizationID])
)
WITH
(
MEMORY_OPTIMIZED = ON,
DURABILITY = SCHEMA_ONLY
)
GO
PRINT N'Creating [dbo].[Table_with_5M_rows]'
GO
IF OBJECT_ID(N'[dbo].[Table_with_5M_rows]', 'U') IS NULL
CREATE TABLE [dbo].[Table_with_5M_rows]
(
[OrderItemID] [bigint] NOT NULL,
[OrderID] [int] NULL,
[Price] [int] NULL,
[ProductName] [nvarchar] (103) NOT NULL
)
GO
PRINT N'Creating index [CL_Table_with_5M_rows_ColumnStore] on [dbo].[Table_with_5M_rows]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'CL_Table_with_5M_rows_ColumnStore' AND object_id = OBJECT_ID(N'[dbo].[Table_with_5M_rows]'))
CREATE CLUSTERED COLUMNSTORE INDEX [CL_Table_with_5M_rows_ColumnStore] ON [dbo].[Table_with_5M_rows]
GO
PRINT N'Creating [dbo].[TestRowCompression]'
GO
IF OBJECT_ID(N'[dbo].[TestRowCompression]', 'U') IS NULL
CREATE TABLE [dbo].[TestRowCompression]
(
[TestID] [int] NOT NULL,
[Data] [nvarchar] (2000) NOT NULL
)
GO
PRINT N'Creating index [IX_DepartmentHistory_SystemEndTime_SystemStartTime_DeptID] on [dbo].[DepartmentHistory]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_DepartmentHistory_SystemEndTime_SystemStartTime_DeptID' AND object_id = OBJECT_ID(N'[dbo].[DepartmentHistory]'))
CREATE NONCLUSTERED INDEX [IX_DepartmentHistory_SystemEndTime_SystemStartTime_DeptID] ON [dbo].[DepartmentHistory] ([SystemEndTime], [SystemStartTime], [DeptID])
GO
PRINT N'Adding foreign keys to [Hierarchy].[Personnel]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Hierarchy].[FK_Personnel_Employee_EmployeeID]', 'F') AND parent_object_id = OBJECT_ID(N'[Hierarchy].[Personnel]', 'U'))
ALTER TABLE [Hierarchy].[Personnel] ADD CONSTRAINT [FK_Personnel_Employee_EmployeeID] FOREIGN KEY ([EmployeeID]) REFERENCES [Hierarchy].[Employee] ([EmployeeID])
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Hierarchy].[FK_Personnel_Employee_ManagerID]', 'F') AND parent_object_id = OBJECT_ID(N'[Hierarchy].[Personnel]', 'U'))
ALTER TABLE [Hierarchy].[Personnel] ADD CONSTRAINT [FK_Personnel_Employee_ManagerID] FOREIGN KEY ([ManagerID]) REFERENCES [Hierarchy].[Employee] ([EmployeeID])
GO
PRINT N'Adding foreign keys to [Hierarchy].[PersonnelEmployee]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Hierarchy].[FK_PersonnelEmployee_PersonnelEmployee_ManagerID]', 'F') AND parent_object_id = OBJECT_ID(N'[Hierarchy].[PersonnelEmployee]', 'U'))
ALTER TABLE [Hierarchy].[PersonnelEmployee] ADD CONSTRAINT [FK_PersonnelEmployee_PersonnelEmployee_ManagerID] FOREIGN KEY ([ManagerID]) REFERENCES [Hierarchy].[PersonnelEmployee] ([PersonnelEmployeeID])
GO
