CREATE TABLE [dbo].[DiskStall] (
    [ID]                     BIGINT          NOT NULL,
    [ServerName]             NVARCHAR (128)  NULL,
    [InstanceName]           NVARCHAR (128)  NULL,
    [DatabaseID]             SMALLINT        NOT NULL,
    [DatabaseName]           NVARCHAR (128)  NOT NULL,
    [PhysicalFileName]       NVARCHAR (260)  NOT NULL,
    [DatabaseFileID]         INT             NOT NULL,
    [AvgReadStallms]         NUMERIC (10, 1) NULL,
    [AvgWriteStallms]        NUMERIC (10, 1) NULL,
    [IOStallReadms]          BIGINT          NULL,
    [NumOfReads]             BIGINT          NULL,
    [IOStallWritems]         BIGINT          NULL,
    [NumOfWrites]            BIGINT          NULL,
    [TotalNumOfBytesRead]    BIGINT          NULL,
    [TotalNumOfBytesWritten] BIGINT          NULL,
    [CollectionDateTime]     DATETIME        NOT NULL,
    CONSTRAINT [PK_DiskStall_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);

