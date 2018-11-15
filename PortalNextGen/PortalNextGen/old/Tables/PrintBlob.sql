CREATE TABLE [old].[PrintBlob] (
    [PrintBlobID]     INT             IDENTITY (1, 1) NOT NULL,
    [PrintRequestID]  INT             NOT NULL,
    [NumberOfBytes]   INT             NOT NULL,
    [Value]           VARBINARY (MAX) NOT NULL,
    [CreatedDateTime] DATETIME2 (7)   CONSTRAINT [DF_PrintBlob_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintBlob_PrintBlobID] PRIMARY KEY CLUSTERED ([PrintBlobID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintBlob_PrintRequest_PrintRequestID] FOREIGN KEY ([PrintRequestID]) REFERENCES [old].[PrintRequest] ([PrintRequestID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PrintBlob';

