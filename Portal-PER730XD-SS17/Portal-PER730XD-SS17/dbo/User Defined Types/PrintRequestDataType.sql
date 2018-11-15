CREATE TYPE [dbo].[PrintRequestDataType] AS TABLE (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [Name]           VARCHAR (50)     NULL,
    [Value]          VARCHAR (MAX)    NULL);

