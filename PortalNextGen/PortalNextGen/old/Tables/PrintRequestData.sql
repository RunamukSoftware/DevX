CREATE TABLE [old].[PrintRequestData] (
    [PrintRequestDataID] INT           IDENTITY (1, 1) NOT NULL,
    [PrintRequestID]     INT           NOT NULL,
    [Name]               VARCHAR (50)  NULL,
    [Value]              VARCHAR (MAX) NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_PrintRequestData_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PrintRequestData_PrintRequestDataID] PRIMARY KEY CLUSTERED ([PrintRequestDataID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_PrintRequestData_PrintRequest_PrintRequestID] FOREIGN KEY ([PrintRequestID]) REFERENCES [old].[PrintRequest] ([PrintRequestID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'TABLE', @level1name = N'PrintRequestData';

