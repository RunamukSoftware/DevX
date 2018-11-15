CREATE TYPE [dbo].[BlobDataType] AS TABLE (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [PrintRequestId] UNIQUEIDENTIFIER NOT NULL,
    [NumBytes]       INT              NOT NULL,
    [Value]          VARBINARY (MAX)  NOT NULL);

