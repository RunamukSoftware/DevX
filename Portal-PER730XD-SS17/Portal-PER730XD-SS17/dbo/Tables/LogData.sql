CREATE TABLE [dbo].[LogData]
    ([LogId] UNIQUEIDENTIFIER NOT NULL,
     [DateTime] DATETIME NOT NULL,
     [PatientID] VARCHAR(256) NULL,
     [Application] NVARCHAR(256) NULL,
     [DeviceName] NVARCHAR(256) NULL,
     [Message] NVARCHAR(MAX) NOT NULL,
     [LocalizedMessage] NVARCHAR(MAX) NULL,
     [MessageId] INT NULL,
     [LogType] NVARCHAR(64) NOT NULL,
     [Sequence] BIGINT IDENTITY(-9223372036854775808, 1) NOT NULL,
     CONSTRAINT [PK_LogData_Sequence]
         PRIMARY KEY CLUSTERED ([Sequence] ASC)
         WITH (FILLFACTOR = 100));
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Contains error log information',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'LogData';
