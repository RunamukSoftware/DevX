CREATE TYPE [old].[utpKeyValueTable] AS TABLE (
    [ApplicationType] VARCHAR (50)   NOT NULL,
    [InstanceID]      VARCHAR (50)   NOT NULL,
    [Key]             VARCHAR (50)   NOT NULL,
    [Value]           VARCHAR (5000) NULL);

