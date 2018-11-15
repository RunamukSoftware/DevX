CREATE TYPE [dbo].[KeyValueTableType] AS TABLE (
    [ApplicationType] VARCHAR (50)   NOT NULL,
    [InstanceId]      VARCHAR (50)   NOT NULL,
    [Key]             VARCHAR (50)   NOT NULL,
    [Value]           VARCHAR (5000) NULL);

