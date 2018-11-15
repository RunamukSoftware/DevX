CREATE TABLE [dbo].[AuditLogData]
    ([AuditId] UNIQUEIDENTIFIER NOT NULL,
     [DateTime] DATETIME NOT NULL,
     [PatientID] VARCHAR(256) NOT NULL,
     [Application] NVARCHAR(256) NULL,
     [DeviceName] NVARCHAR(256) NULL,
     [Message] NVARCHAR(MAX) NOT NULL,
     [ItemName] NVARCHAR(256) NOT NULL,
     [OriginalValue] NVARCHAR(MAX) NOT NULL,
     [NewValue] NVARCHAR(MAX) NOT NULL,
     [ChangedBy] NVARCHAR(64) NOT NULL,
     [HashedValue] BINARY(20) NOT NULL,
     [Sequence] BIGINT IDENTITY(-9223372036854775808, 1) NOT NULL,
     CONSTRAINT [PK_AuditLogData_Sequence]
         PRIMARY KEY CLUSTERED ([Sequence] ASC));
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Contains audit log information',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'AuditLogData';
