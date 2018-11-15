CREATE TABLE [old].[PrintRequest] (
    [PrintRequestID]       INT           IDENTITY (1, 1) NOT NULL,
    [PrintJobID]           INT           NOT NULL,
    [RequestTypeEnumID]    INT           NOT NULL,
    [RequestTypeEnumValue] INT           NOT NULL,
    [Timestamp]            DATETIME2 (7) NOT NULL,
    [CreatedDateTime]      DATETIME2 (7) CONSTRAINT [DF_PrintRequest_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintRequest_PrintRequestID] PRIMARY KEY CLUSTERED ([PrintRequestID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintRequest_PrintJob_PrintJobID] FOREIGN KEY ([PrintJobID]) REFERENCES [old].[PrintJob] ([PrintJobID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PrintRequest';

