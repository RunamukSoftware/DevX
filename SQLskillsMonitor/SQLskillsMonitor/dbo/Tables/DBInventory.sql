CREATE TABLE [dbo].[DBInventory] (
    [ServerName]       VARCHAR (100)  NULL,
    [DatabaseName]     VARCHAR (100)  NULL,
    [LogicalFileName]  [sysname]      NOT NULL,
    [FileGroupName]    VARCHAR (100)  NULL,
    [Growth]           VARCHAR (25)   NULL,
    [FileSizeMB]       INT            NULL,
    [UsedSizeMB]       INT            NULL,
    [FreeSpaceMB]      INT            NULL,
    [PhysicalFileName] NVARCHAR (520) NULL,
    [Status]           [sysname]      NOT NULL,
    [Updateability]    [sysname]      NOT NULL,
    [RecoveryMode]     [sysname]      NOT NULL,
    [FreeSpacePct]     NUMERIC (5, 2) NULL,
    [CAPTURE_DATE]     DATETIME       NULL
);

