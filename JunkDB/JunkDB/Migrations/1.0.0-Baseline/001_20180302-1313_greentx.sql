-- <Migration ID="8d47c1fd-61ba-431e-a4b0-008648d0eeb6" />
GO

PRINT N'Creating schemas'
GO
PRINT N'Creating [dbo].[BillionNumber]'
GO
CREATE TABLE [dbo].[BillionNumber]
(
[Number] [bigint] NULL
)
GO
PRINT N'Creating index [CIX_BillionNumber_Number] on [dbo].[BillionNumber]'
GO
CREATE UNIQUE CLUSTERED INDEX [CIX_BillionNumber_Number] ON [dbo].[BillionNumber] ([Number])
GO
PRINT N'Creating [dbo].[Example]'
GO
CREATE TABLE [dbo].[Example]
(
[SomeID] [int] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NOT NULL
)
GO
PRINT N'Creating index [CX_Example_SomeID_StartDate] on [dbo].[Example]'
GO
CREATE CLUSTERED INDEX [CX_Example_SomeID_StartDate] ON [dbo].[Example] ([SomeID], [StartDate])
GO
PRINT N'Creating [dbo].[FirstName]'
GO
CREATE TABLE [dbo].[FirstName]
(
[FirstNameID] [int] NOT NULL,
[FirstName] [nvarchar] (100) NOT NULL
)
GO
PRINT N'Creating [dbo].[LastName]'
GO
CREATE TABLE [dbo].[LastName]
(
[LastNameID] [int] NOT NULL,
[LastName] [nvarchar] (100) NOT NULL
)
GO
PRINT N'Creating [dbo].[MillionNumber]'
GO
CREATE TABLE [dbo].[MillionNumber]
(
[Number] [bigint] NULL
)
GO
PRINT N'Creating index [CIX_Number] on [dbo].[MillionNumber]'
GO
CREATE UNIQUE CLUSTERED INDEX [CIX_Number] ON [dbo].[MillionNumber] ([Number])
GO
PRINT N'Creating [dbo].[PivotTest]'
GO
CREATE TABLE [dbo].[PivotTest]
(
[PivotTestID] [int] NOT NULL IDENTITY(1, 1),
[LinkID] [int] NOT NULL,
[Key] [varchar] (20) NOT NULL,
[Value] [varchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_PivotTest] on [dbo].[PivotTest]'
GO
ALTER TABLE [dbo].[PivotTest] ADD CONSTRAINT [PK_PivotTest] PRIMARY KEY CLUSTERED  ([PivotTestID])
GO
PRINT N'Creating [dbo].[T1]'
GO
CREATE TABLE [dbo].[T1]
(
[pk] [int] NOT NULL,
[c1] [decimal] (9, 0) NULL
)
GO
PRINT N'Creating primary key [PK_dbo_T1] on [dbo].[T1]'
GO
ALTER TABLE [dbo].[T1] ADD CONSTRAINT [PK_dbo_T1] PRIMARY KEY CLUSTERED  ([pk])
GO
PRINT N'Creating [dbo].[T2]'
GO
CREATE TABLE [dbo].[T2]
(
[pk] [int] NOT NULL,
[c1] [decimal] (9, 0) NULL
)
GO
PRINT N'Creating primary key [PK_dbo_T2] on [dbo].[T2]'
GO
ALTER TABLE [dbo].[T2] ADD CONSTRAINT [PK_dbo_T2] PRIMARY KEY CLUSTERED  ([pk])
GO
