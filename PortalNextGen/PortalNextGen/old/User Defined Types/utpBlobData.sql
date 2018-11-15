CREATE TYPE [old].[utpBlobData] AS TABLE (
    [BlobDataID]     INT             NOT NULL,
    [PrintRequestID] INT             NOT NULL,
    [NumberOfBytes]  INT             NOT NULL,
    [Value]          VARBINARY (MAX) NOT NULL);

