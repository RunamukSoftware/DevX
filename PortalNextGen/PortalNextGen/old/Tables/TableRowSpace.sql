CREATE TABLE [old].[TableRowSpace] (
    [TableRowSpaceID] INT            IDENTITY (1, 1) NOT NULL,
    [DatabaseName]    NVARCHAR (128) NOT NULL,
    [SchemaName]      NVARCHAR (128) NOT NULL,
    [TableName]       NVARCHAR (128) NOT NULL,
    [IndexName]       NVARCHAR (128) NULL,
    [RowCount]        INT            NOT NULL,
    [TotalSpaceKB]    INT            NOT NULL,
    [UsedSpaceKB]     INT            NOT NULL,
    [UnusedSpaceKB]   INT            NOT NULL,
    [CreatedDateTime] DATETIME2 (7)  CONSTRAINT [DF_TableRowSpace_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [IndexID]         INT            NOT NULL,
    CONSTRAINT [PK_TableRowSpace_TableRowSpaceID] PRIMARY KEY CLUSTERED ([TableRowSpaceID] ASC) WITH (FILLFACTOR = 100)
);

